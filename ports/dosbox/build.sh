#!/bin/bash
# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.


DOSBOX_EXAMPLE_DIR=${NACL_SRC}/ports/dosbox-0.74
EXECUTABLES=src/dosbox${NACL_EXEEXT}

ConfigureStep() {
  SetupCrossEnvironment

  export LIBS="-L${NACLPORTS_LIBDIR} \
      -lm \
      -lpng \
      -lz"

  # --as-needed is needed during confgiure otherwise a lot of tests
  # will fail to link undefined 'SDLmain'
  export LDFLAGS="${NACLPORTS_LDFLAGS} -Wl,--as-needed"

  local conf_host=${NACL_CROSS_PREFIX}
  if [ ${NACL_ARCH} = "pnacl" ]; then
    # The PNaCl tools use "pnacl-" as the prefix, but config.sub
    # does not know about "pnacl".  It only knows about "le32-nacl".
    # Unfortunately, most of the config.subs here are so old that
    # it doesn't know about that "le32" either.  So we just say "nacl".
    conf_host="nacl"
  fi

  CONFIG_FLAGS="--host=${conf_host} \
      --prefix=${NACLPORTS_PREFIX} \
      --exec-prefix=${NACLPORTS_PREFIX} \
      --libdir=${NACLPORTS_LIBDIR} \
      --oldincludedir=${NACLPORTS_INCLUDE} \
      --with-sdl-prefix=${NACLPORTS_PREFIX} \
      --disable-shared \
      --with-sdl-exec-prefix=${NACLPORTS_PREFIX}"

  # TODO(clchiou): Sadly we cannot export LIBS and LDFLAGS to configure, which
  # would fail due to multiple definitions of main and missing pp::CreateModule.
  # So we patch auto-generated Makefile after running configure.
  export PPAPI_LIBS=""
  export LIBS="-lnacl_io"
  LogExecute ../configure ${CONFIG_FLAGS}

  SED_PREPEND_LIBS="s|^LIBS = \(.*$\)|LIBS = ${PPAPI_LIBS} \1|"
  SED_REPLACE_LDFLAGS="s|^LDFLAGS = .*$|LDFLAGS = ${NACLPORTS_LDFLAGS}|"

  find . -name Makefile -exec cp {} {}.bak \; \
      -exec sed -i.bak "${SED_PREPEND_LIBS}" {} \; \
      -exec sed -i.bak "${SED_REPLACE_LDFLAGS}" {} \;
}

InstallStep(){
  MakeDir ${PUBLISH_DIR}
  LogExecute install ${START_DIR}/dosbox.html ${PUBLISH_DIR}
  LogExecute install src/dosbox${NACL_EXEEXT} \
    ${PUBLISH_DIR}/dosbox_${NACL_ARCH}${NACL_EXEEXT}
  local CREATE_NMF="${NACL_SDK_ROOT}/tools/create_nmf.py"
  LogExecute ${CREATE_NMF} -s ${PUBLISH_DIR} ${PUBLISH_DIR}/dosbox_*${NACL_EXEEXT} -o ${PUBLISH_DIR}/dosbox.nmf
}
