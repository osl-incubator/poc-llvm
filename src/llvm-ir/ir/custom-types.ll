; example:
; %Foo = type {
;   i64,    ; index 0 = x
;   double  ; index 1 = y
; }

%st.Float = type {
    float  ; index 0 = x
}

%st.Bool = type {
    i8  ; index 0 = x
}

%st.I32 = type {
    i32  ; index 0 = x
}

%st.All = type {
  %st.Float,
  %st.Bool
}
