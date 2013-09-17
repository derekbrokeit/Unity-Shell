# setup prefered compilers on linux distros
if os_is_linux ; then
    host="SSE4.2"
    default_opt="-O2"

    # Fortran
    # ifort > gfortran
    if is_avail ifort ; then
        export FC=ifort
        export F77=ifort
        export FCFLAGS="-O3 -x$host -ipo"
    fi

    # c-compilers
    # icc > clang > gcc
    if is_avail icc ; then
        export CC=icc
        export CFLAGS="-O3 -x$host -ipo"
    elif is_avail clang ; then
        export CC=clang
        export CFLAGS=$default_opt
    elif is_avail gcc-4.9 ; then
        export CC=gcc-4.9
        export CFLAGS=$default_opt
    fi

    # c++-compilers
    # icpc > clang++ > g++
    if is_avail icpc ; then
        export CXX=icpc
        export CXXFLAGS="-O3 -x$host -ipo"
    elif is_avail clang++ ; then
        export CXX=clang++
        export CXXFLAGS=$default_opt
    elif is_avail g++-4.9 ; then
        export CXX=g++-4.9
        export CXXFLAGS=$default_opt
    fi

    unset host
    unset default_opt
fi
