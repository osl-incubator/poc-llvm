#include <arrow/scalar.h>

extern "C" arrow::BooleanScalar* arrow_scalar_bool(int value);
extern "C" arrow::FloatScalar* arrow_scalar_float(float value);
