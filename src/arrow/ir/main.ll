target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._GArrowScalar = type { i8 }
%struct._GArrowInt32Scalar = type { %struct._GArrowScalar, i32 }

@.str = private unnamed_addr constant [5 x i8] c"%d\n\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  ; create the int32 scalar and assign the value 42
  %scalar = alloca %struct._GArrowInt32Scalar
  %value_ptr = getelementptr %struct._GArrowInt32Scalar, %struct._GArrowInt32Scalar* %scalar, i32 0, i32 1
  store i32 42, i32* %value_ptr

  ; extract the value from the scalar and print it
  %loaded_value_ptr = getelementptr %struct._GArrowInt32Scalar, %struct._GArrowInt32Scalar* %scalar, i32 0, i32 1
  %loaded_value = load i32, i32* %loaded_value_ptr
  %str = getelementptr [5 x i8], [5 x i8]* @.str, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %str, i32 %loaded_value)
  ret i32 0
}
