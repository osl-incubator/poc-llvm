project('poccpp-llvm-cpp', 'cpp', 'c',
  license : 'BSD-3-Clause',
  version : '1.0.0',  # semantic-release
  default_options : [
    'warning_level=3',
    'cpp_std=c++20',
  ]
)

PROJECT_PATH = meson.source_root()

cxx = meson.get_compiler('cpp')

llvm_modules = [
  'core',
  'executionengine',
  'object',
  'orcjit',
  'support',
  'native',
]

deps = [
  dependency('llvm', version : '>=15.0.0', modules : llvm_modules),
]

inc = include_directories('./src')

project_src_files = files(PROJECT_PATH + '/src/llvmcpp.cpp')

poccpp_exe = executable(
  'pocllvmcpp',
  project_src_files + files(PROJECT_PATH + '/src/main.cpp'),
  dependencies : deps,
  include_directories : inc,
  install : true)
