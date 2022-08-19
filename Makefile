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
	clang -v \
		main.ll \
		function.ll \
		-o pocllvmir.o \
		-Wl,-rpath,external/add.o \
		external/add.o \
		${CONDA_PREFIX}/lib/libarrow-dataset-glib.so \
		${CONDA_PREFIX}/lib/libarrow-flight-glib.so \
		${CONDA_PREFIX}/lib/libarrow-glib.so


.ONESHELL:
.PHONY: llvm-ir-run
llvm-ir-run: llvm-ir-build
	cd pocllvm/ir
	./pocllvmir.o
