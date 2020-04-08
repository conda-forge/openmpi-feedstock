#!/bin/bash

# unset unused old fortran compiler vars
unset F90 F77

set -e

export FCFLAGS="$FFLAGS"

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

if [ $(uname) == Darwin ]; then
    if [[ ! -z "$CONDA_BUILD_SYSROOT" ]]; then
        export CFLAGS="$CFLAGS -isysroot $CONDA_BUILD_SYSROOT"
        export CXXFLAGS="$CXXFLAGS -isysroot $CONDA_BUILD_SYSROOT"
    fi
    export LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib"
fi

if [ $cuda_compiler_version == '9.2' ]; then
    build_with_cuda="--with-cuda"
else
    build_with_cuda=""
fi

export LIBRARY_PATH="$PREFIX/lib"

./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --enable-mpi-fortran \
            --disable-wrapper-rpath \
            --disable-wrapper-runpath \
            --with-wrapper-cflags="-I$PREFIX/include" \
            --with-wrapper-cxxflags="-I$PREFIX/include" \
            --with-wrapper-fcflags="-I$PREFIX/include" \
            --with-wrapper-ldflags="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib" \
            --with-sge \
            $build_with_cuda

make -j"${CPU_COUNT:-1}"
make install

if [ ! -z "$build_with_cuda" ]; then
    echo "setting the mca opal_warn_on_missing_libcuda to 0..."
    echo "opal_warn_on_missing_libcuda = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    echo "setting the mca opal_cuda_support to 0..."
    echo "opal_cuda_support = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    
    POST_LINK=$PREFIX/bin/.openmpi-post-link.sh
    cp $RECIPE_DIR/post-link.sh $POST_LINK
    chmod +x $POST_LINK
fi

if [ $(uname) == Darwin ]; then
    # workaround for open-mpi/ompi#7516
    echo "setting the mca gds to hash..."
    echo "gds = hash" >> $PREFIX/etc/pmix-mca-params.conf

    # workaround for open-mpi/ompi#5798
    echo "setting the mca btl_vader_backing_directory to /tmp..."
    echo "btl_vader_backing_directory = /tmp" >> $PREFIX/etc/openmpi-mca-params.conf
fi
