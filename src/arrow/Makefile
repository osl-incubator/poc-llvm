# path
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# build
CLEAN:=0

# build flags
BUILD_TYPE=release


.PHONY: clean-optional
clean-optional:
	bash ./scripts/optclean.sh
	mkdir -p build

.ONESHELL:
.PHONY: build-cpp
build-cpp: clean-optional
	set -ex
	meson setup \
		--prefix ${CONDA_PREFIX} \
		--libdir ${CONDA_PREFIX}/lib \
		--includedir ${CONDA_PREFIX}/include \
		--buildtype=${BUILD_TYPE} \
		--native-file meson.native ${ARGS} \
		build .
	meson compile -C build

.ONESHELL:
.PHONY: build-cpp-libs-file
build-cpp-libs-file:
	set -ex

	$(eval PROJECT_ROOT :=${PWD})
	$(eval BUILD_DIR :=${PROJECT_ROOT}/build)
	$(eval BUILD_LIB_DIR :=${BUILD_DIR}/lib)
	$(eval SRC_DIR :=${PROJECT_ROOT}/src)

	mkdir -p ${BUILD_LIB_DIR}

	clang++ -fPIC \
		-I${CONDA_PREFIX}/include \
		-I${SRC_DIR} \
		-L${CONDA_PREFIX}/lib \
		-L${BUILD_LIB_DIR}/lib \
		-c ${SRC_DIR}/${CPP_FILE_NAME}.cpp \
		-o ${BUILD_LIB_DIR}/${CPP_FILE_NAME}.o

	clang -shared \
		-o ${BUILD_LIB_DIR}/lib${CPP_FILE_NAME}.so \
		${BUILD_LIB_DIR}/${CPP_FILE_NAME}.o

	ar -rv \
		${BUILD_LIB_DIR}/${CPP_FILE_NAME}.a \
		${BUILD_LIB_DIR}/${CPP_FILE_NAME}.o


.ONESHELL:
.PHONY: build-cpp-libs
build-cpp-libs: build-cpp
	set -ex
	$(MAKE) build-cpp-libs-file CPP_FILE_NAME=simple-math
	$(MAKE) build-cpp-libs-file CPP_FILE_NAME=arrow-wrap

.ONESHELL:
.PHONY: test-cpp-libs
test-cpp-libs: build-cpp-libs
	set -ex

	$(eval PROJECT_ROOT :=${PWD})
	$(eval BUILD_DIR :=${PROJECT_ROOT}/build)
	$(eval SRC_DIR :=${PROJECT_ROOT}/src)

	clang++ \
		-fPIC \
		-I${CONDA_PREFIX}/include \
		-I${SRC_DIR}/ \
		-L${CONDA_PREFIX}/lib \
		-L${BUILD_DIR}/lib/ \
		-larrow \
		-lsimple-math \
		-larrow-wrap \
		-Wl,-rpath,${CONDA_PREFIX}/lib/libarrow.so \
		-Wl,-rpath,${BUILD_DIR}/lib/libsimple-math.so \
		-Wl,-rpath,${BUILD_DIR}/lib/libarrow-wrap.so \
		-o ${BUILD_DIR}/lib/test_externals.o \
		-v \
		${PROJECT_ROOT}/tests/test_externals.cpp


	echo "[II] file compiled."
	chmod +x ${BUILD_DIR}/lib/test_externals.o
	LD_LIBRARY_PATH="${CONDA_PREFIX}/lib:${BUILD_DIR}/lib" ${BUILD_DIR}/lib/test_externals.o


.ONESHELL:
.PHONY: build-llvm-ir-file
build-llvm-ir-file:
	set -ex
	$(eval PROJECT_ROOT :=${PWD})
	$(eval BUILD_DIR :=${PROJECT_ROOT}/build)
	$(eval SRC_DIR :=${PWD}/src)
	cd ${SRC_DIR}

	echo ">>> llc ${FILE_IR}.ll"
	llc --relocation-model=pic \
		${SRC_DIR}/ir/${FILE_IR}.ll \
		-filetype=obj \
		-o ${BUILD_DIR}/lib/ll${FILE_IR}.o \
		--load=${BUILD_DIR}/lib

.ONESHELL:
.PHONY: build-llvm-ir
build-llvm-ir: build-cpp-libs
	set -ex
	$(eval PROJECT_ROOT :=${PWD})
	$(eval BUILD_DIR :=${PROJECT_ROOT}/build)
	$(eval SRC_DIR :=${PWD}/src)

	$(MAKE) build-llvm-ir-file FILE_IR=function
	$(MAKE) build-llvm-ir-file FILE_IR=arrow
	$(MAKE) build-llvm-ir-file FILE_IR=custom-types
	$(MAKE) build-llvm-ir-file FILE_IR=main

	echo ">>> bundle .o files"
	clang++ -v \
		-fPIC \
		-o ${BUILD_DIR}/pocllvmir \
		-I${CONDA_PREFIX}/include \
		-I${SRC_DIR} \
		-L${BUILD_DIR}/lib \
		-L${CONDA_PREFIX}/lib/ \
		-fuse-ld=lld \
		-larrow \
		-larrow-wrap \
		-lsimple-math \
		-Wl,-rpath,${CONDA_PREFIX}/lib/libarrow.so \
		-Wl,-rpath,${BUILD_DIR}/lib/libarrow-wrap.so \
		-Wl,-rpath,${BUILD_DIR}/lib/libsimple-math.so \
		-lstdc++ \
		-v \
		${BUILD_DIR}/lib/llmain.o \
		${BUILD_DIR}/lib/llfunction.o \
		${BUILD_DIR}/lib/llcustom-types.o \
		${BUILD_DIR}/lib/llarrow.o


.ONESHELL:
.PHONY: test-llvm-ir
test-llvm-ir: build-llvm-ir
	$(eval BUILD_DIR :=${PWD}/build)

	LD_LIBRARY_PATH=${CONDA_PREFIX}/lib:${BUILD_DIR}/lib ${BUILD_DIR}/pocllvmir


.ONESHELL:
.PHONY: test-llvm-ir-objects
test-llvm-ir-objects:
	set -ex

	$(eval PROJECT_ROOT :=${PWD})
	$(eval BUILD_DIR :=${PROJECT_ROOT}/build)
	$(eval BUILD_LIB_DIR :=${BUILD_DIR}/lib)
	$(eval SRC_DIR :=${PROJECT_ROOT}/src)

	clang++ \
		-fPIC \
		-I${CONDA_PREFIX}/include \
		-I${SRC_DIR}/ \
		-L${CONDA_PREFIX}/lib \
		-L${BUILD_LIB_DIR}/ \
		-larrow \
		-lsimple-math \
		-larrow-wrap \
		-Wl,-rpath,${CONDA_PREFIX}/lib/libarrow.so \
		-Wl,-rpath,${BUILD_LIB_DIR}/libsimple-math.so \
		-Wl,-rpath,${BUILD_LIB_DIR}/libarrow-wrap.so \
		-o ${BUILD_LIB_DIR}/test_ir.o \
		-v \
		${BUILD_LIB_DIR}/llarrow.o \
		${BUILD_LIB_DIR}/llcustom-types.o \
		${BUILD_LIB_DIR}/llfunction.o \
		${PROJECT_ROOT}/tests/test_ir.cpp

	echo "[II] file compiled."
	chmod +x ${BUILD_DIR}/lib/test_ir.o
	LD_LIBRARY_PATH="${CONDA_PREFIX}/lib:${BUILD_DIR}/lib" ${BUILD_DIR}/lib/test_ir.o
