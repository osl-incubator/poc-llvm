; from cpp
declare i8* @arrow_scalar_bool(i32)
declare float* @arrow_scalar_float(float)

define i8* @ir_arrow_scalar_bool(i32 %n) {
  %arrow_bool = call i8* @arrow_scalar_bool(i32 %n)
  ret i8* %arrow_bool
}

define float* @ir_arrow_scalar_float(float %n) {
  %arrow_float = call float* @arrow_scalar_float(float %n)
  ret float* %arrow_float
}
