#!/usr/bin/env bash

[[ -z $1 ]] && echo "error: source directory was not provided" && exit 1
SRC_DIR=$1

INSTALL_PREFIX="$2"
[[ -z $2 ]] && INSTALL_PREFIX="${SRC_DIR}/../install/"

[[ -z $AnnotateLoops_DIR ]] && echo "error: AnnotateLoops_DIR is not set" && exit 2
[[ -z ${LLVMPOLLY_ROOT} ]] && echo "error: LLVMPOLLY_ROOT is not set" && exit 2

PIPELINE_CONFIG_FILE="${SRC_DIR}/config/pipelines/pollywithidle.txt"
BMK_CONFIG_FILE="${SRC_DIR}/config/suite_all.txt"
BMK_CLASS="S"

#

C_FLAGS="-g -Wall -O3"
LINKER_FLAGS="-Wl,-L$(llvm-config --libdir) -Wl,-rpath=$(llvm-config --libdir)"
LINKER_FLAGS="${LINKER_FLAGS} -lc++ -lc++abi" 

CC=clang CXX=clang++ \
  cmake \
  -DCMAKE_POLICY_DEFAULT_CMP0056=NEW \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DLLVM_DIR=$(llvm-config --prefix)/share/llvm/cmake/ \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS="${C_FLAGS}" \
  -DCMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_SHARED_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_MODULE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
  -DHARNESS_USE_LLVM=On \
  -DHARNESS_PIPELINE_CONFIG_FILE=${PIPELINE_CONFIG_FILE} \
  -DHARNESS_BMK_CONFIG_FILE=${BMK_CONFIG_FILE} \
  -DBMK_CLASS=${BMK_CLASS} \
  -DAnnotateLoops_DIR=${AnnotateLoops_DIR} \
  -DLLVMPOLLY_ROOT=${LLVMPOLLY_ROOT} \
  "${SRC_DIR}"

exit $?

