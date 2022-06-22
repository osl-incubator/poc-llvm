@msg = internal constant [16 x i8] c"Hello function!\00"

declare i32 @puts(i8*)

define i32 @function() {
  call i32 @puts(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @msg, i32 0, i32 0))
  ret i32 0
}
