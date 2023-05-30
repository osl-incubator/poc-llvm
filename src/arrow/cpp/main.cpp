#include <arrow-glib/arrow-glib.h>
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"

llvm::LLVMContext CONTEXT;
llvm::Module MODULE("example", CONTEXT);

llvm::FunctionType* mainType;
llvm::Function* mainFunc;
llvm::BasicBlock* entry;

llvm::Type* LLVM_DOUBLE_TYPE = nullptr;
llvm::Type* LLVM_FLOAT_TYPE = nullptr;
llvm::Type* LLVM_INT8_TYPE = nullptr;
llvm::Type* LLVM_INT32_TYPE = nullptr;

auto llvm_initialize() -> void {
  LLVM_DOUBLE_TYPE = llvm::Type::getDoubleTy(CONTEXT);
  LLVM_FLOAT_TYPE = llvm::Type::getFloatTy(CONTEXT);
  LLVM_INT8_TYPE = llvm::Type::getInt8Ty(CONTEXT);
  LLVM_INT32_TYPE = llvm::Type::getInt32Ty(CONTEXT);
}
auto llvm_create_main_fn() -> void {
  // create main function
  mainType = llvm::FunctionType::get(LLVM_INT32_TYPE, false);
  mainFunc = llvm::Function::Create(
      mainType, llvm::Function::ExternalLinkage, "main", &MODULE);
  entry = llvm::BasicBlock::Create(CONTEXT, "entry", mainFunc);
}

auto llvm_create_arrow_i32(llvm::BasicBlock* entry_block, int value) -> llvm::AllocaInst* {
  // create int32 scalar and assign the given value
  llvm::StructType* int32ScalarType =
      llvm::StructType::create(CONTEXT, "struct._GArrowInt32Scalar");

  llvm::Type* int32Fields[] = {
      llvm::Type::getInt8Ty(CONTEXT), LLVM_INT32_TYPE};

  int32ScalarType->setBody(int32Fields);

  llvm::AllocaInst* scalar =
      new llvm::AllocaInst(int32ScalarType, 0, "scalar", entry_block);

  llvm::Value* zero =
      llvm::ConstantInt::get(LLVM_INT32_TYPE, 0);
  llvm::Value* one =
      llvm::ConstantInt::get(LLVM_INT32_TYPE, 1);

  llvm::Value* valuePtr = llvm::GetElementPtrInst::CreateInBounds(
      int32ScalarType, scalar, {zero, one}, "", entry_block);

  llvm::StoreInst* store = new llvm::StoreInst(
      llvm::ConstantInt::get(LLVM_INT32_TYPE, value),
      valuePtr,
      false,
      entry_block);

  return scalar;
}

int main() {
  llvm_initialize();
  llvm_create_main_fn();
  scalar = llvm_create_arrow_i32(entry, 42);

  // return 0 from main
  llvm::ReturnInst::Create(
      CONTEXT,
      llvm::ConstantInt::get(LLVM_INT32_TYPE, 0),
      entry);

  // verify the MODULE and print IR
  verifyModule(MODULE, &llvm::outs());
  MODULE.print(llvm::outs(), nullptr);

  return 0;
}
