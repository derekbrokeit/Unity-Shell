# setup prefered compilers on linux distros
if os_is_linux ; then
    local host="SSE4.2"
    local default_opt="-O2 -m$host"

    # Fortran
    # ifort > gfortran
    if is_avail ifort ; then
        FC=ifort
        F77=ifort
        FCFLAGS="-O3 -x$host -ipo"
    else
        FC=gfortran
        F77=gfortran
        FCFLAGS=$default_opt
    fi
    export FC
    export F77
    export FCFLAGS

    # c-compilers
    # icc > clang > gcc
    if is_avail icc ; then
        CC=icc
        CFLAGS="-O3 -x$host -ipo"
    elif is_avail clang ; then
        CC=clang
        CFLAGS=$default_opt
    else
        CC=gcc
        CFLAGS=$default_opt
    fi
    export CC
    export CFLAGS

    # c++-compilers
    # icpc > clang++ > g++
    if is_avail icpc ; then
        CXX=icpc
        CXXFLAGS="-O3 -x$host -ipo"
    elif is_avail clang++ ; then
        CXX=clang++
        CXXFLAGS=$default_opt
    else
        CXX=g++
        CXXFLAGS=$default_opt
    fi
    export CXX
    export CXXFLAGS
fi
