#!/bin/bash
# Copyright (c) 2014 Che-Liang Chiou. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

ConfigureStep() {
  if [ -z "${CHROME_DOSBOX_SRC_DIR:-}" ]; then
    echo "Missing CHROME_DOSBOX_SRC_DIR"
    exit 1
  fi

  Banner "Copy Makefile"
  cp -f ${CHROME_DOSBOX_SRC_DIR}/Makefile ${BUILD_DIR}

  # TODO(clchiou): How to communicate with Makefile?
  Banner "Write config file"
  echo '# Config variables' > ${BUILD_DIR}/config.mk
  echo "SRC_DIR=${CHROME_DOSBOX_SRC_DIR}" >> ${BUILD_DIR}/config.mk
  echo "BUILD_DIR=${BUILD_DIR}" >> ${BUILD_DIR}/config.mk
  echo "DEST_DIR=${NACLPORTS_PREFIX}" >> ${BUILD_DIR}/config.mk
  echo "AR=${NACLAR}" >> ${BUILD_DIR}/config.mk
  echo "CC=${NACLCC}" >> ${BUILD_DIR}/config.mk
  echo "CXX=${NACLCXX}" >> ${BUILD_DIR}/config.mk
  echo "CFLAGS=${NACLPORTS_CFLAGS}" >> ${BUILD_DIR}/config.mk
  echo "CPPFLAGS=${NACLPORTS_CPPFLAGS}" >> ${BUILD_DIR}/config.mk
  echo "CXXFLAGS=${NACLPORTS_CXXFLAGS}" >> ${BUILD_DIR}/config.mk
  local DOSBOX_SVN_SENTINEL="$(${TOOLS_DIR}/get_sentinel.py dosbox-svn)"
  echo "DOSBOX_SVN_SENTINEL=${DOSBOX_SVN_SENTINEL}" >> ${BUILD_DIR}/config.mk
}
