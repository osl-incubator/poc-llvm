#include <stdio.h>
#include <iostream>
#include "simple-math.h"
#include "arrow-wrap.h"


int main() {
  int add_result = simple_add(1, 2);
  std::cout << "simple_add(1, 2) expects 3. Result: " << add_result << std::endl;
  std::cout << "wrap_arrow_bool(1) expects 1. Result: ";
  printf("%i \n", wrap_arrow_bool(1).value);

  return 0;
}
