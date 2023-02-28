%st.Bool = type { i8 }
%st.Float = type { float }
%st.I32 = type { i32 }

; Definition of main function
define i32 @main() {   ; i32()*
  %f_struct = alloca %st.Float

  %1 = getelementptr %st.Float, ptr %f_struct, i32 0
  ; %2 = getelementptr float, float %1, i32 0, i32 0
  store %2, float 0x400928F5C0000000
  store ptr %1, float %2

  ret i32 0
}
