#!/usr/bin/env python

import sys
import os
import pyperclip  # 3rd party... do: pip install --user pyperclip

if len(sys.argv) != 2:
    sys.exit(1)
    print("fail")
pt = sys.argv[1]
if os.path.exists(pt):
    ptf = os.path.abspath(os.path.expandvars(os.path.expanduser(pt)))
    pyperclip.copy(ptf)
else:
    sys.exit(1)
