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
.PHONY: build
build: clean-optional
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
.PHONY: llvm-ir-clean
llvm-ir-clean:
	rm -f pocllvm/ir/*.o
	rm -f pocllvm/ir/*.so
	rm -f pocllvm/ir/external/*.o
	rm -f pocllvm/ir/external/lib/*.so

.ONESHELL:
.PHONY: llvm-ir-build-external
llvm-ir-build-external: llvm-ir-clean
	set -ex
	cd pocllvm/ir/external
	mkdir -p lib

	# create the "simple-math" object
	clang++ -fPIC \
		-I${CONDA_PREFIX}/include \
		-I./ \
		-L${CONDA_PREFIX}/lib \
		-c simple-math.c \
		-o simple-math.o

	# create the "simple-math" shared object
	clang -shared -o lib/libsimple-math.so simple-math.o

	# create the "simple-math" static object
	ar -rv lib/simple-math.a simple-math.o

	# create the arrow-wrap object
	clang++ -fPIC \
		-I${CONDA_PREFIX}/include \
		-I./ \
		-L${CONDA_PREFIX}/lib \
		-larrow \
		-c \
		-o arrow-wrap.o \
		arrow-wrap.cpp

	# create the arrow-wrap shared object
	clang -shared -o ./lib/libarrow-wrap.so arrow-wrap.o

	# create the arrow-wrap static object
	ar -rv ./lib/arrow-wrap.a arrow-wrap.o

.PHONY: test-externals
.ONESHELL:
test-externals:  llvm-ir-build-external
	set -ex
	$(eval REAL_PWD :=${PWD}/pocllvm/ir/external)
	cd ${REAL_PWD}

	clang++ \
		-fPIC \
		-I${CONDA_PREFIX}/include \
		-I${REAL_PWD}/ \
		-L${CONDA_PREFIX}/lib \
		-L${REAL_PWD}/lib/ \
		-larrow \
		-lsimple-math \
		-larrow-wrap \
		-Wl,-rpath,${CONDA_PREFIX}/lib/libarrow.so \
		-Wl,-rpath,${REAL_PWD}/lib/libsimple-math.so \
		-Wl,-rpath,${REAL_PWD}/lib/libarrow-wrap.so \
		-o test_externals.o \
		-v \
		test_externals.cpp \
		${REAL_PWD}/lib/libsimple-math.so \
		${REAL_PWD}/lib/libarrow-wrap.so


	echo "[II] file compiled."
	chmod +x ./test_externals.o
	LD_LIBRARY_PATH="${CONDA_PREFIX}/lib:${REAL_PWD}/lib" ./test_externals.o


.ONESHELL:
.PHONY: llvm-ir-build
llvm-ir-build: llvm-ir-clean llvm-ir-build-external
	set -ex
	$(eval REAL_PWD :=${PWD}/pocllvm/ir)
	cd ${REAL_PWD}

	clang++ -v \
		-fPIC \
		-o pocllvmir.o \
		-I${CONDA_PREFIX}/include \
		-I${REAL_PWD}/external \
		-L${CONDA_PREFIX}/lib/ \
		-L${REAL_PWD}/external/lib \
		-larrow \
		-larrow-wrap \
		-lsimple-math \
		-Wl,-rpath,${CONDA_PREFIX}/lib/libarrow.so \
		-Wl,-rpath,${REAL_PWD}/external/lib/libarrow-wrap.so \
		-Wl,-rpath,${REAL_PWD}/external/lib/libsimple-math.so \
		-lstdc++ \
		-v \
		main.ll \
		function.ll \
		arrow.ll


.ONESHELL:
.PHONY: llvm-ir-run
llvm-ir-run: llvm-ir-build
	cd pocllvm/ir
	LD_LIBRARY_PATH=${CONDA_PREFIX}/lib  ./pocllvmir.o
