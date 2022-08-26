#include <arrow/scalar.h>

extern "C" auto arrow_scalar_bool(int value) -> arrow::BooleanScalar* {
  auto result = arrow::BooleanScalar(value);
  arrow::BooleanScalar* result_ptr = &result;
  return result_ptr;
}


extern "C" auto arrow_scalar_float(float value) -> arrow::FloatScalar* {
  auto result = arrow::FloatScalar(value);
  arrow::FloatScalar* result_ptr = &result;
  return result_ptr;
}
