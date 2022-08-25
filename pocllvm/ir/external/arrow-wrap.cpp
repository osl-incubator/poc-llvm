#include <arrow/scalar.h>

auto wrap_arrow_bool(int value) -> arrow::BooleanScalar {
  return arrow::BooleanScalar(value);
}
