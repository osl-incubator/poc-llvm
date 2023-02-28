; Declare the string constant as a global constant.
@.message_hello = private unnamed_addr constant [13 x i8] c"hello world!\00"
@.message_bye = private unnamed_addr constant [9 x i8] c"bye bye!\00"
@formatString = private unnamed_addr constant [4 x i8] c"%i\0A\00", align 1

; External declaration of the puts function
declare i32 @puts(i8* nocapture) nounwind
declare i32 @wrap_puts()
declare i32 @simple_add(i32, i32)
declare i32 @printf(i8*, ...)

%BoolStruct = type { i8 }
%FloatStruct = type { float }

; Definition of main function
define i32 @main() {   ; i32()*
  ; Convert [13 x i8]* to i8*...
  %cast_hello = getelementptr [13 x i8], [13 x i8]* @.message_hello, i64 0, i64 0
  %cast_bye = getelementptr [9 x i8], [9 x i8]* @.message_bye, i64 0, i64 0

  ; Call puts function to write out the string to stdout.
  call i32 @puts(i8* %cast_hello)
  call i32 @puts(i8* %cast_bye)

  %result = call i32 @simple_add(i32 1, i32 5)

  call i32 (i8*, ...) @printf(
    i8* getelementptr inbounds (
      [4 x i8], [4 x i8]* @formatString, i64 0, i64 0
    ), i32 %result
  )

  call i32 @wrap_puts()

  %f_struct = alloca %FloatStruct

  %5 = getelementptr %FloatStruct, %FloatStruct * %f_struct, i32 0, i32 0
  ; store float %5, float 0x400928F5C0000000

  ret i32 0
}

; Named metadata
!0 = !{i32 42, null, !"string"}
!foo = !{!0}
