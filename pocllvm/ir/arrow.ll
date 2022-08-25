declare i32* @wrap_arrow_bool(i8)

define i32* @boolean_scalar() {
  %arrow_bool = call i32* @wrap_arrow_bool(i8 1)
  ret i32* %arrow_bool
}
