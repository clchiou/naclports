#!/bin/bash
# Copyright (c) 2013 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

BUILD_DIR=${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}

ConfigureStep() {
  Banner "Configuring ${PACKAGE_NAME}"
  # export the nacl tools
  export CC=${NACLCC}
  export CXX=${NACLCXX}
  export AR=${NACLAR}
  export RANLIB=${NACLRANLIB}
  ChangeDir ${BUILD_DIR}
  ./unmaintained/autogen.sh \
    --host=nacl \
    --prefix=${NACLPORTS_PREFIX}
}
