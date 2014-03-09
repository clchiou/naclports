#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

export BUILD_CC=cc

# parallel build usually fails (at least for me)
OS_JOBS=1
MAKE_TARGETS="f2clib blaslib lib"

ConfigureStep() {
  if [ $OS_NAME != "Darwin" ]; then
    # -u: do not rewrite newer with older files
    UPDATE=-u
  else
    UPDATE=
  fi

  MakeDir ${BUILD_DIR}
  ChangeDir ${BUILD_DIR}
  LogExecute cp ${UPDATE} -R ../BLAS ../F2CLIBS ../INSTALL ../TESTING ../INCLUDE ../SRC ./
  LogExecute cp ${UPDATE} ../Makefile ../make.inc ./

  # make does not create it, but build relays on it being there
  LogExecute install -d SRC/VARIANTS/LIB
}

# Without the -m option the x86_64 and arm builds break with (x86_64)
#
# at build-nacl-x86_64-glibc/F2CLIBS/f2clibs
#
# …/nacl_sdk/pepper_canary/toolchain/linux_x86_glibc/bin/x86_64-nacl-ld  -r
# -o main.xxx main.o
#
# Relocatable linking with relocations from format elf64-x86-64-nacl (main.o) to
# format elf32-x86-64-nacl (main.xxx) is not supported
#
# TODO: Investigate/remove this and a later date
LDEMULATION=
[[ "${NACL_ARCH}" == "x86_64" ]] && LDEMULATION=-melf_x86_64_nacl
[[ "${NACL_ARCH}" == "arm" ]] && LDEMULATION=-marmelf_nacl
export LDEMULATION

TestStep() {
  ChangeDir ${BUILD_DIR}/INSTALL
  RunSelLdrCommand ./testlsame
  RunSelLdrCommand ./testslamch
  RunSelLdrCommand ./testdlamch
  RunSelLdrCommand ./testsecond
  RunSelLdrCommand ./testdsecnd
  RunSelLdrCommand ./testversion
}

# the Makefile does not contain install target
InstallStep() {
  ChangeDir ${BUILD_DIR}
  LogExecute install libblas.a ${NACLPORTS_LIBDIR}
  LogExecute install liblapack.a ${NACLPORTS_LIBDIR}
  LogExecute install tmglib.a ${NACLPORTS_LIBDIR}
  LogExecute install F2CLIBS/libf2c.a ${NACLPORTS_LIBDIR}
}
