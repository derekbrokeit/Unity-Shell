# ---- From: http://docs.python.org/tutorial/interactive.html
# Add auto-completion and a stored history file of commands to your Python
# interactive interpreter. Requires Python 2.0+, readline. Autocomplete is
# bound to the Esc key by default (you can change it - see readline docs).
#
# Store the file in ~/.pystartup, and set an environment variable to point
# to it:  "export PYTHONSTARTUP=~/.pystartup" in bash.

import atexit
import os
import readline
import rlcompleter

historyPath = os.path.expanduser("~/.pyhistory")

def save_history(historyPath=historyPath):
    import readline
    readline.write_history_file(historyPath)

if os.path.exists(historyPath):
    readline.read_history_file(historyPath)

atexit.register(save_history)
# del os, atexit, readline, rlcompleter, save_history, historyPath
del atexit, readline, rlcompleter, save_history, historyPath
# ----

# ---- From: http://docs.scipy.org/doc/scipy/reference/tutorial/index.html
# import science related modules
import numpy as np
import scipy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
# ----

# welcome message
print "Welcome!"

