#!/usr/bin/env python
# Copyright (c) 2014 Che-Liang Chiou. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import os
import sys

import naclports

def main(args):
  if not args:
    print 'Usage: %s pkg_name' % os.path.basename(sys.argv[0])
    return 1
  print naclports.SentinelFile(args[0])
  return 0

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
