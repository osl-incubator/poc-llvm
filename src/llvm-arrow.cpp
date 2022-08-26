#include <arrow/api.h>
#include <arrow/csv/api.h>
#include <arrow/io/api.h>
#include <arrow/ipc/api.h>
#include <arrow/pretty_print.h>
#include <arrow/result.h>
#include <arrow/status.h>
#include <arrow/table.h>

#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <map>
#include <memory>
#include <string>
#include <system_error>
#include <utility>
#include <vector>

#include <glog/logging.h>

#include <llvm/ADT/APFloat.h>
#include <llvm/ADT/Optional.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/Analysis/BasicAliasAnalysis.h>
#include <llvm/Analysis/Passes.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DIBuilder.h>
#include <llvm/IR/DataLayout.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/MC/TargetRegistry.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Host.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Target/TargetMachine.h>
#include <llvm/Target/TargetOptions.h>
#include <llvm/Transforms/Scalar.h>

std::unique_ptr<llvm::LLVMContext> code_context;
std::unique_ptr<llvm::IRBuilder<>> code_builder;
std::unique_ptr<llvm::Module> code_module;

auto initialize() -> void {
  // context
  std::unique_ptr<llvm::LLVMContext> code_context =
      std::make_unique<llvm::LLVMContext>();
  // builder
  std::unique_ptr<llvm::IRBuilder<>> code_builder =
      std::unique_ptr<llvm::IRBuilder<>>(new llvm::IRBuilder<>(*code_context));
  // module
  std::unique_ptr<llvm::Module> code_module =
      std::make_unique<llvm::Module>("Module", *code_context);
}

auto llvm_arrow_main() -> int {
  initialize();

  auto const_int = llvm::ConstantInt::getSigned(
      (llvm::Type::getInt32Ty(*code_context)), 10);

  return 0;
}
