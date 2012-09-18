#!/bin/sh

pushd . > /dev/null
abs_path=$(cd "$(dirname $0)" ; pwd)
cd $abs_path

if [[ "$1" == "clean" ]] ; then
    pushd . > /dev/null
    cd bundle/stderred
    if [[ -n $DYLD_INSERT_LIBRARIES ]] ; then
        temp=$DYLD_INSERT_LIBRARIES
        unset $DYLD_INSERT_LIBRARIES
    fi
    make clean
    popd > /dev/null

    pushd . > /dev/null
    cd bundle/tig
    make
    make clean
    popd > /dev/null
else
    pushd . > /dev/null
    cd bundle/stderred
    if [[ -n $DYLD_INSERT_LIBRARIES ]] ; then
        temp=$DYLD_INSERT_LIBRARIES
        unset DYLD_INSERT_LIBRARIES
    fi
    make all
    if [[ -n $temp ]] ; then
        export DYLD_INSERT_LIBRARIES=$temp
    fi
    popd > /dev/null

    pushd . > /dev/null
    cd bundle/tig
    make
    make install install-doc
    popd > /dev/null

    pushd . > /dev/null
    cd bundle/matplotlib
    python setup.py build
    if [[ "$COMP_TYPE" == "local" ]] ; then
        echo
        pwd
        echo "sudo python setup.py install"
        sudo python setup.py install
    else
        python setup.py install
    fi
    popd > /dev/null
fi
popd > /dev/null
