#include <string>

#include <llvm/ADT/APFloat.h>           // for APFloat
#include <llvm/ADT/iterator_range.h>    // for iterator_range
#include <llvm/ADT/Optional.h>          // for Optional
#include <llvm/ADT/StringRef.h>         // for StringRef
#include <llvm/ADT/Twine.h>             // for Twine
#include <llvm/IR/Argument.h>           // for Argument
#include <llvm/IR/BasicBlock.h>         // for BasicBlock
#include <llvm/IR/Constant.h>           // for Constant
#include <llvm/IR/Constants.h>          // for ConstantFP
#include <llvm/IR/DerivedTypes.h>       // for FunctionType
#include <llvm/IR/Function.h>           // for Function
#include <llvm/IR/Instructions.h>       // for AllocaInst, CallInst, PHINode
#include <llvm/IR/IRBuilder.h>          // for IRBuilder
#include <llvm/IR/LegacyPassManager.h>  // for PassManager
#include <llvm/IR/LLVMContext.h>        // for LLVMContext
#include <llvm/IR/Module.h>             // for Module
#include <llvm/IR/Type.h>               // for Type
#include <llvm/IR/Verifier.h>           // for verifyFunction
#include <llvm/MC/TargetRegistry.h>     // for Target, TargetRegistry
#include <llvm/Support/CodeGen.h>       // for CodeGenFileType, Model
#include <llvm/Support/FileSystem.h>    // for OpenFlags
#include <llvm/Support/Host.h>          // for getDefaultTargetTriple
#include <llvm/Support/raw_ostream.h>   // for errs, raw_fd_ostream, raw_ost...
#include <llvm/Support/TargetSelect.h>  // for InitializeAllAsmParsers, Init...
#include <llvm/Target/TargetMachine.h>  // for TargetMachine
#include <llvm/Target/TargetOptions.h>  // for TargetOptions
#include <cstdio>                       // for fprintf, stderr
#include <cstdlib>                      // for exit
#include <fstream>                      // for operator<<
#include <map>                          // for map
#include <memory>                       // for unique_ptr, make_unique
#include <string>                       // for string, operator<=>
#include <utility>                      // for move
#include <vector>                       // for vector

#include "llvmcpp.h"

std::unique_ptr<llvm::LLVMContext> POCLLVM::context;
std::unique_ptr<llvm::Module> POCLLVM::module;
std::unique_ptr<llvm::IRBuilder<>> POCLLVM::ir_builder;
std::unique_ptr<llvm::DIBuilder> POCLLVM::di_builder;

std::map<std::string, llvm::AllocaInst*> POCLLVM::named_values;

/* Data types */
llvm::Type* POCLLVM::DOUBLE_TYPE;
llvm::Type* POCLLVM::FLOAT_TYPE;
llvm::Type* POCLLVM::INT8_TYPE;
llvm::Type* POCLLVM::INT32_TYPE;
llvm::Type* POCLLVM::VOID_TYPE;

auto POCLLVM::get_data_type(std::string type_name) -> llvm::Type* {
  if (type_name == "float") {
    return POCLLVM::FLOAT_TYPE;
  } else if (type_name == "void") {
    return POCLLVM::VOID_TYPE;
  } else if (type_name == "char") {
    return POCLLVM::INT8_TYPE;
  }
  return nullptr;
}

extern bool IS_BUILD_LIB = false;  // default value

auto initialize() -> void {
  POCLLVM::context = std::make_unique<llvm::LLVMContext>();
  POCLLVM::module =
    std::make_unique<llvm::Module>("arx jit", *POCLLVM::context);

  /** Create a new builder for the module. */
  POCLLVM::ir_builder = std::make_unique<llvm::IRBuilder<>>(*POCLLVM::context);

  POCLLVM::DOUBLE_TYPE = llvm::Type::getDoubleTy(*POCLLVM::context);
  POCLLVM::FLOAT_TYPE = llvm::Type::getFloatTy(*POCLLVM::context);
  POCLLVM::INT8_TYPE = llvm::Type::getInt8Ty(*POCLLVM::context);
  POCLLVM::INT32_TYPE = llvm::Type::getInt32Ty(*POCLLVM::context);
  POCLLVM::VOID_TYPE = llvm::Type::getVoidTy(*POCLLVM::context);
}

auto compile() -> int {
  initialize();

  // Initialize the target registry etc.
  llvm::InitializeAllTargetInfos();
  llvm::InitializeAllTargets();
  llvm::InitializeAllTargetMCs();
  llvm::InitializeAllAsmParsers();
  llvm::InitializeAllAsmPrinters();

  auto TargetTriple = llvm::sys::getDefaultTargetTriple();
  POCLLVM::module->setTargetTriple(TargetTriple);

  std::string Error;
  auto Target = llvm::TargetRegistry::lookupTarget(TargetTriple, Error);

  auto CPU = "generic";
  auto Features = "";

  llvm::TargetOptions opt;
  auto RM = llvm::Optional<llvm::Reloc::Model>();

  auto TheTargetMachine =
    Target->createTargetMachine(TargetTriple, CPU, Features, opt, RM);


  POCLLVM::module->setDataLayout(TheTargetMachine->createDataLayout());

  std::error_code EC;

  std::string OUTPUT_FILE = "/tmp/pocllvm.o";

  llvm::raw_fd_ostream dest(OUTPUT_FILE, EC, llvm::sys::fs::OF_None);

  if (EC) {
    llvm::errs() << "Could not open file: " << EC.message();
    return 1;
  }

  llvm::legacy::PassManager pass;

  auto FileType = llvm::CGFT_ObjectFile;

  if (TheTargetMachine->addPassesToEmitFile(pass, dest, nullptr, FileType)) {
    llvm::errs() << "TheTargetMachine can't emit a file of this type";
    return 1;
  }

  pass.run(*POCLLVM::module);
  dest.flush();

  delete TheTargetMachine;
  return 0;
}
