#!/usr/bin/env python

from __future__ import division, print_function

import shutil
import sys
import os

def makeAndMove(toMove, useTempName=False):
    basename, filext = os.path.splitext(toMove)
    folderName = basename+'_TEMP' if useTempName else basename
    os.mkdir(folderName)
    shutil.move(toMove, os.path.join(folderName, toMove))
    if useTempName:
        os.rename(folderName, basename)

def main():
    if len(sys.argv) != 2:
        print('        Usage:  Moves a file foo.bar to path foo/foo.bar or folder foo to foo/foo')
        sys.exit(0)

    inName = sys.argv[1].rstrip('/')
    if os.path.exists(inName):
        basename, filext = os.path.splitext(inName)
        if os.path.isfile(inName):  # input argument is a file
            if len(filext):
                makeAndMove(inName)
            else:
                makeAndMove(inName, useTempName=True)
        else:  # input argument is a folder
            makeAndMove(inName, useTempName=True)
    else:
        print("specified path doesn't exist!")
        sys.exit(1)


if __name__ == '__main__':
    main()
