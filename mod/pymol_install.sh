#!/bin/sh

cd /tmp
svn co https://pymol.svn.sourceforge.net/svnroot/pymol/trunk/pymol pymol
cd pymol

prefix=$HOME/bin
modules=$prefix/modules

python setup.py build install \
        --home=$prefix \
        --install-lib=$modules

export PYTHONPATH=$modules:$PYTHONPATH
python setup2.py install
install pymol $prefix/
