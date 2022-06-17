cmake_minimum_required(VERSION 3.21)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

set(TARGET_NAME pocllvm)

project(${TARGET_NAME})

include(c++-standards)
cxx_17()

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld")

set(PROJECT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_PATH}/bin)
message(STATUS "PROJECT_PATH: ${PROJECT_PATH}")
message(STATUS "EXECUTABLE_OUTPUT_PATH: ${EXECUTABLE_OUTPUT_PATH}")

find_package(LLVM REQUIRED CONFIG)
find_package(Arrow REQUIRED)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
message(STATUS "LLVM_TARGETS_TO_BUILD: ${LLVM_TARGETS_TO_BUILD}")

find_package(glog REQUIRED)
message(STATUS "Found glog ${glog_VERSION}")

find_package(CLI11 CONFIG REQUIRED)
message(STATUS "Found CLI ${CLI11_VERSION}")

# Set your project compile flags. E.g. if using the C++ header files you will
# need to enable C++11 support for your compiler.

include_directories(${LLVM_INCLUDE_DIRS} ${PROJECT_PATH}/pocllvm/include)
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

# Now build our tools
set(POCLLVM_LIB_SOURCES
    ${PROJECT_PATH}/pocllvm/src/main.cpp
    ${PROJECT_PATH}/pocllvm/src/llvm_arrow.cpp
    )

set(POCLLVM_SOURCES ${PROJECT_PATH}/pocllvm/src/main.cpp ${POCLLVM_LIB_SOURCES})

add_executable(pocllvm ${POCLLVM_SOURCES})

# Find the libraries that correspond to the LLVM components that we wish to use
llvm_map_components_to_libnames(
  llvm_libs
  support
  core
  irreader
  orcjit
  mcjit
  native
  object
  executionengine
  all
  ${LLVM_TARGETS_TO_BUILD})

install(TARGETS pocllvm DESTINATION bin)
target_link_libraries(pocllvm PRIVATE arrow_shared)
