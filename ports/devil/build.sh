#!/bin/bash
# Copyright (c) 2013 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

TestStep() {
  return 0

  if [ ${NACL_ARCH} == "pnacl" ]; then
    # Run once for each architecture.
    local pexe=test/testil
    local script=${pexe}.sh

    TranslateAndWriteSelLdrScript ${pexe} x86-32 ${pexe}.x86-32.nexe ${script}
    (cd test && make check)

    TranslateAndWriteSelLdrScript ${pexe} x86-64 ${pexe}.x86-64.nexe ${script}
    (cd test && make check)
  else
    local nexe=test/testil
    local script=${nexe}.sh

    WriteSelLdrScript ${script} ${nexe}

    (cd test && make check)
  fi
}
