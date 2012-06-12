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

# import science related modules
import numpy as np
from numpy import array
import scipy as sp
import pylab as p
import matplotlib as mpl

# my linux machines do not have monitors
import platform
# if platform.system() == 'Linux':
try:
    display = os.environ['DISPLAY']
except KeyError:
    # use the Agg interface so that it doesn't try to use DISPLAY
    mpl.use('Agg')
import matplotlib.pyplot as plt

# welcome message
print "Welcome!"

