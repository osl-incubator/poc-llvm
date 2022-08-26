declare i8* @wrap_arrow_bool(i32)

define i8* @boolean_scalar() {
  %arrow_bool = call i8* @wrap_arrow_bool(i32 1)
  ret i8* %arrow_bool
}
