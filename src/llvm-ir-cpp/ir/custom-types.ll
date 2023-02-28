; example:
; %Foo = type {
;   i64,    ; index 0 = x
;   double  ; index 1 = y
; }

%struct.Float = type {
    float  ; index 0 = x
}

%struct.Bool = type {
    i8  ; index 0 = x
}

%struct.All = type {
  %struct.Float,
  %struct.Bool
}
