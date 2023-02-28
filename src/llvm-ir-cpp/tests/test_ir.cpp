#include <stdio.h>
#include <iostream>

#include <arrow/scalar.h>

arrow::BooleanScalar* ir_arrow_scalar_bool(int);
arrow::FloatScalar* ir_arrow_scalar_float(float);

void test_ir() {
  std::cout << "ir_arrow_scalar_bool(1) expects 1. Result: ";
  printf("%i \n", ir_arrow_scalar_bool(1));

  std::cout << "arrow_scalar_float(1.2345) expects 1.2345. Result: ";
  printf("%f \n", ir_arrow_scalar_float(1.2345));
}

int main() {
  std::cout << "Test IR functions" << std::endl;
  test_ir();

  return 0;
}
