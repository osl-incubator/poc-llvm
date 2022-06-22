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
	mkdir -p $(ROOT_DIR)/build/bin
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

.ONESHELL:
.PHONY: llvm-ir-clean
llvm-ir-clean:
	cd pocllvm/ir
	rm -f *.o
	cd pocllvm/ir/external
	rm -f *.o

.ONESHELL:
.PHONY: llvm-ir-build-external
llvm-ir-build-external: llvm-ir-clean
	cd pocllvm/ir/external
	clang -fPIC -c add.c -o add.o


.ONESHELL:
.PHONY: llvm-ir-build
llvm-ir-build: llvm-ir-clean llvm-ir-build-external
	cd pocllvm/ir
	clang \
		main.ll \
		function.ll \
		-o pocllvmir.o \
		-Wl,-rpath,external/add.o \
		external/add.o


.ONESHELL:
.PHONY: llvm-ir-run
llvm-ir-run: llvm-ir-build
	cd pocllvm/ir
	./pocllvmir.o
