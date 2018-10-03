#!/bin/bash

# unset unused old fortran flags
unset F90 F77

# this might not be needed?
export FCFLAGS="$FFLAGS"

if [ $(uname) == Darwin ]; then
    export LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib"
fi

export LIBRARY_PATH="$PREFIX/lib"

./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --enable-mpi-cxx \
            --enable-mpi-fortran

make -j"${CPU_COUNT:-1}"
make install
