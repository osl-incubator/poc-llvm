# path
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# build
ROOT=cd pocllvm
COMPILER=$(ROOT) && clang++
CLEAN=0
CXX=clang++
CC=clang

# build flags
CMAKE_EXTRA_FLAGS=
CMAKE_BUILD_TYPE=release


.PHONY: clean-optional
clean-optional:
	bash ./scripts/optclean.sh
	mkdir -p build


.ONESHELL:
.PHONY: cmake-build
cmake-build: clean-optional
	mkdir -p $(ROOT_DIR)/bin
	cd $(ROOT_DIR)/build
	cmake \
		-GNinja \
		-DCMAKE_INSTALL_PREFIX=${CONDA_PREFIX} \
		-DCMAKE_PREFIX_PATH=${CONDA_PREFIX} \
		-DCMAKE_C_COMPILER=${CC} \
    	-DCMAKE_CXX_COMPILER=${CXX} \
		-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
		--log-level=TRACE \
		-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
		${CMAKE_EXTRA_FLAGS} \
		..
	cmake --build .
