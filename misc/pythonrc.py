# ---- From: http://docs.python.org/tutorial/interactive.html
# Add auto-completion and a stored history file of commands to your Python
# interactive interpreter. Requires Python 2.0+, readline. Autocomplete is
# bound to the Esc key by default (you can change it - see readline docs).

import atexit
import os
import readline

historyPath = os.path.expanduser("~/.pyhistory")

def save_history(historyPath=historyPath):
    import readline
    readline.write_history_file(historyPath)

if os.path.exists(historyPath):
    readline.read_history_file(historyPath)

atexit.register(save_history)
del atexit, readline, save_history, historyPath

# ----
# third party modules
# ----

# science related modules
import math as m
import numpy as np
import numpy.linalg as la
from numpy import array, sqrt, sin, cos, tan, arccos, arcsin, arctan, pi
import scipy as sp
from scipy import optimize as opt
import quantities as pq

# import matplotlib
import matplotlib as mpl
try:
    display = os.environ['DISPLAY']
except KeyError:
    # use the Agg interface so that it doesn't try to use DISPLAY
    mpl.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure, show
import pylab as p

# cryspy imports
import cryspy.lattice.supercell as sc
from cryspy.lattice.network import Network
from cryspy.dump import dump_xyz

try:
    import ccad.model as cm
    import ccad.display as cd
except ImportError:
    print('Problem importing ccad!')

# welcome message
print("Welcome!")

