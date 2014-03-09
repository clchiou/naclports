#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.


TestStep() {
  if [ "${NACL_GLIBC}" = "1" ]; then
    local exe_dir=.libs
  else
    local exe_dir=
  fi

  export SEL_LDR_LIB_PATH=$PWD/src/${exe_dir}
  pushd UnitTests/BulletUnitTests/${exe_dir}
  RunSelLdrCommand AppBulletUnitTests${NACL_EXEEXT}
  popd

  pushd Demos/HelloWorld/${exe_dir}
  RunSelLdrCommand AppHelloWorld${NACL_EXEEXT}
  popd
}


AutogenStep() {
  # Remove \r\n from the shell script.
  # The default sed on Mac is broken. Work around it by using $'...' to have
  # bash convert \r to a carriage return.
  sed -i.bak $'s/\r//g' ./autogen.sh
  /bin/sh ./autogen.sh
  # install-sh is extracted without the execute bit set; for some reason this
  # works OK on Linux, but fails on Mac.
  chmod +x install-sh
  PatchConfigure
  PatchConfigSub
}


ConfigureStep() {
  ChangeDir ${SRC_DIR}
  AutogenStep
  ChangeDir ${BUILD_DIR}
  DefaultConfigureStep
}
