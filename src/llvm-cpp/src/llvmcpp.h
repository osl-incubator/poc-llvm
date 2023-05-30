#pragma once

#include <map>

#include <llvm/IR/DIBuilder.h>   // for DIBuilder
#include <llvm/IR/IRBuilder.h>   // for IRBuilder
#include <llvm/IR/Module.h>      // for Module
#include <llvm/Support/Error.h>  // for ExitOnError

class POCLLVM {
 public:
  static std::unique_ptr<llvm::LLVMContext> context;
  static std::unique_ptr<llvm::Module> module;
  static std::unique_ptr<llvm::IRBuilder<>> ir_builder;
  static std::unique_ptr<llvm::DIBuilder> di_builder;

  static std::map<std::string, llvm::AllocaInst*> named_values;

  /* Data types */
  static llvm::Type* DOUBLE_TYPE;
  static llvm::Type* FLOAT_TYPE;
  static llvm::Type* INT8_TYPE;
  static llvm::Type* INT32_TYPE;
  static llvm::Type* VOID_TYPE;

  static auto get_data_type(std::string type_name) -> llvm::Type*;
};

extern bool IS_BUILD_LIB;


auto compile() -> int;
