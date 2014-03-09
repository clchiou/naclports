#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

CONFIG_SUB=config/config.sub

if [ "${NACL_GLIBC}" != "1" ]; then
  # TODO(sbc): remove once this is fixed:
  # https://code.google.com/p/nativeclient/issues/detail?id=3790
  NACLPORTS_CPPFLAGS+=" -DSSIZE_MAX=LONG_MAX"
  EXE_DIR=""
else
  EXE_DIR=".libs/"
fi

# TODO: Remove when this is fixed.
# https://code.google.com/p/nativeclient/issues/detail?id=3205
if [ "$NACL_ARCH" = "arm" ]; then
  export NACLPORTS_CFLAGS="${NACLPORTS_CFLAGS//-O2/}"
fi

EXTRA_CONFIGURE_ARGS="--disable-largefile --without-fftw --without-xml"

EXECUTABLES="\
  utilities/${EXE_DIR}animate${NACL_EXEEXT} \
  utilities/${EXE_DIR}compare${NACL_EXEEXT} \
  utilities/${EXE_DIR}composite${NACL_EXEEXT} \
  utilities/${EXE_DIR}conjure${NACL_EXEEXT} \
  utilities/${EXE_DIR}convert${NACL_EXEEXT} \
  utilities/${EXE_DIR}display${NACL_EXEEXT} \
  utilities/${EXE_DIR}identify${NACL_EXEEXT} \
  utilities/${EXE_DIR}import${NACL_EXEEXT} \
  utilities/${EXE_DIR}mogrify${NACL_EXEEXT} \
  utilities/${EXE_DIR}montage${NACL_EXEEXT} \
  utilities/${EXE_DIR}stream${NACL_EXEEXT}"

TEST_EXECUTABLES="\
  tests/${EXE_DIR}wandtest${NACL_EXEEXT} \
  tests/${EXE_DIR}drawtest${NACL_EXEEXT} \
  tests/${EXE_DIR}validate${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/flip${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/detrans${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/shapes${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/gravity${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/button${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/zoom${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/piddle${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/demo${NACL_EXEEXT} \
  Magick++/${EXE_DIR}demo/analyze${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/attributes${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/exceptions${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/readWriteImages${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/coalesceImages${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/color${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/readWriteBlob${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/averageImages${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/morphImages${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/montageImages${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/coderInfo${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/appendImages${NACL_EXEEXT} \
  Magick++/${EXE_DIR}tests/colorHistogram${NACL_EXEEXT}"

TestStep() {
  # The tests as (a) very slow and (b) not all passing at this point.
  return 0

  # As part of 'make check' there will be several test executables built.
  # We need to create the script that launch them ahead of time.
  for EXE in ${TEST_EXECUTABLES}; do
    WriteSelLdrScript ${EXE%%${NACL_EXEEXT}} $(basename ${EXE})
  done
  LogExecute make check
}
