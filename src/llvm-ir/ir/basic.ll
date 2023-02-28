%st.Float = type {
    float  ; index 0 = x
}

%st.I32 = type {
    i32  ; index 0 = x
}

%st.Bool = type {
    i8  ; index 0 = x
}

%myStruct = type { i32 }

define i32 @store_struct() {
    %myStructPtr = alloca %myStruct

    %myInt = getelementptr %myStruct, ptr %myStructPtr, i32 0, i32 0
    store i32 42, ptr %myInt
    %myIntValue = load i32, i32* %myInt
    %result = add i32 %myIntValue, 10

    ret i32 %result
}

define i32 @store_i32() {
  %myVariable = alloca i32
  store i32 1, ptr %myVariable
  %myValue = load i32, ptr %myVariable
  %addResult = add i32 %myValue, 5
  ret i32 %addResult
}

; Definition of main function
define i32 @main() {   ; i32()*
  %st_i32 = alloca %st.I32

  %1 = getelementptr %st.I32, ptr %st_i32, i32 0, i32 0
  ;%2 = getelementptr i32, ptr %1, i32 0
  ;store i32 %2, i32 1

  ret i32 0
}
