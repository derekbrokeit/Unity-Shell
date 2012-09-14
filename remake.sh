#!/bin/sh

pushd . > /dev/null
abs_path=$(cd "$(dirname $0)" ; pwd)
cd $abs_path

if [[ "$1" == "clean" ]] ; then
    pushd . > /dev/null
    cd bundle/stderred
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
    make all
    popd > /dev/null

    pushd . > /dev/null
    cd bundle/tig
    make
    make install install-doc
    popd > /dev/null
fi
popd > /dev/null
