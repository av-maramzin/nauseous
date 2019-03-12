#!/usr/bin/env bash

PRJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)"
SRC_DIR=${1:-$PRJ_ROOT_DIR}
INSTALL_PREFIX=${2:-../install/}

BMK_CONFIG_FILE="${SRC_DIR}/config/suite_all.txt"
BMK_TYPE="OMP"
BMK_CLASS="B"
MG_BMK_CLASS="B"
IS_BMK_CLASS="B"

# use Intel ICC specific flags
ICC_FLAGS="${ICC_FLAGS} -O3"
ICC_FLAGS="${ICC_FLAGS} -g"
ICC_FLAGS="${ICC_FLAGS} -parallel"
ICC_FLAGS="${ICC_FLAGS} -vec"
ICC_FLAGS="${ICC_FLAGS} -ipo"
ICC_FLAGS="${ICC_FLAGS} -ip-no-inlining"
ICC_FLAGS="${ICC_FLAGS} -unroll0"
ICC_FLAGS="${ICC_FLAGS} -mcmodel=medium"
ICC_FLAGS="${ICC_FLAGS} -xHost"
ICC_FLAGS="${ICC_FLAGS} -par-threshold0"
ICC_FLAGS="${ICC_FLAGS} -vec-threshold0"
ICC_FLAGS="${ICC_FLAGS} -qopt-report=5"
ICC_FLAGS="${ICC_FLAGS} -qopt-report-phase=vec,par,loop,ipo"
ICC_FLAGS="${ICC_FLAGS} -qopt-report-file=report.txt"
#ICC_FLAGS="${ICC_FLAGS} -qopenmp"
ICC_FLAGS="${ICC_FLAGS} -debug inline-debug-info"

C_FLAGS="${CMAKE_C_FLAGS} ${ICC_FLAGS}"
CXX_FLAGS="${CMAKE_CXX_FLAGS} ${ICC_FLAGS}"

#C_FLAGS="-g -Wall -O3"
#LINKER_FLAGS="-Wl,-L$(llvm-config --libdir) -Wl,-rpath=$(llvm-config --libdir)"
#LINKER_FLAGS="${LINKER_FLAGS} -lc++ -lc++abi" 

CC=icc CXX=icpc \
cmake \
  -G "Unix Makefiles" \
  -DCMAKE_POLICY_DEFAULT_CMP0056=NEW \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_FLAGS="${C_FLAGS}" \
  -DCMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_SHARED_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_MODULE_LINKER_FLAGS="${LINKER_FLAGS}" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
  -DHARNESS_BMK_CONFIG_FILE=${BMK_CONFIG_FILE} \
  -DBMK_CLASS=${BMK_CLASS} \
  -DBMK_TYPE=${BMK_TYPE} \
  -DMG_BMK_CLASS=${MG_BMK_CLASS} \
  -DIS_BMK_CLASS=${IS_BMK_CLASS} \
  "${SRC_DIR}"

