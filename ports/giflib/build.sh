#!/bin/bash
# Copyright (c) 2013 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.


if [ "${NACL_GLIBC}" = "1" ]; then
  EXECUTABLES=util/.libs/rgb2gif${NACL_EXEEXT}
else
  EXECUTABLES=util/rgb2gif${NACL_EXEEXT}
fi

RunTest() {
  util/rgb2gif -s 320 200  < ../tests/porsche.rgb > porsche.gif
  # TODO(sbc): do some basic checks on the resulting porsche.gif
}

TestStep() {
  if [ "${NACL_GLIBC}" = "1" ]; then
    # TODO(sbc): find out why glibc version of rgb2gif is crashing
    return
  fi

  if [ "${NACL_ARCH}" = "pnacl" ]; then
    local pexe=rgb2gif${NACL_EXEEXT}
    (cd util;
     TranslateAndWriteSelLdrScript ${pexe} x86-32 rgb2gif.x86-32.nexe rgb2gif)
    RunTest
    (cd util;
     TranslateAndWriteSelLdrScript ${pexe} x86-64 rgb2gif.x86-64.nexe rgb2gif)
    RunTest
  else
    RunTest
  fi
}


BuildStep() {
  # Limit the subdirecorties that get built by make. This is to
  # avoid the 'doc' directory which has a dependency on 'xmlto'.
  # If 'xmlto' were added to the host build dependencies this could
  # be removed.
  export PATH=${NACL_BIN_PATH}:${PATH}
  make -j${OS_JOBS} SUBDIRS="lib util"
}
