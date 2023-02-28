#include <stdio.h>
#include <iostream>

#include "../cpp/custom-type.h"
#include "../cpp/simple-math.h"

void test_cpp() {
  int add_result = simple_add(1, 2);
  std::cout << "simple_add(1, 2) expects 3. Result: " << add_result
            << std::endl;

  // std::cout << "arrow_scalar_bool(1) expects 1. Result: ";
  // printf("%i \n", arrow_scalar_bool(1)->value);
  //
  // std::cout << "arrow_scalar_float(1.2345) expects 1.2345. Result: ";
  // printf("%f \n", arrow_scalar_float(1.2345)->value);
}

int main() {
  std::cout << "Test C++ functions" << std::endl;
  test_cpp();

  return 0;
}
