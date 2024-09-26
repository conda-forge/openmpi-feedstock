#!/bin/bash

set -ex

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

# unset unused Fortran compiler variables
unset FFLAGS F77 F90 F95

# add -fallow-argument-mismatch to FCFLAGS
if [[ "$target_platform" != linux-ppc64le ]]; then
   export FCFLAGS="-fallow-argument-mismatch ${FCFLAGS}"
fi

# tweak compiler flags
export LIBRARY_PATH="$PREFIX/lib"
if [[ "$target_platform" == osx-* ]]; then
    # FIXME: remove autogen when autotools patch no longer required
    perl autogen.pl --force
    if [[ -n "$CONDA_BUILD_SYSROOT" ]]; then
        export CFLAGS="$CFLAGS -isysroot $CONDA_BUILD_SYSROOT"
        export CXXFLAGS="$CXXFLAGS -isysroot $CONDA_BUILD_SYSROOT"
    fi
fi

# tweak wrapper ldflags
wrapper_ldflags=""
if [[ "$target_platform" == linux-* ]]; then
    # allow-shlib-undefined required for dependencies to link against older sysroot
    # avoids undefined
    wrapper_ldflags='-Wl,--allow-shlib-undefined'
fi
if [[ "$target_platform" == osx-* ]]; then
    # rpath required for '@rpath/libmpi.*.dylib' to be found at runtime
    wrapper_ldflags='-Wl,-rpath,${libdir}'
fi

# UCX and UCC support
build_with_ucx=""
build_with_ucc=""
if [[ "$target_platform" == linux-* && "$target_platform" != linux-ppc64le ]]; then
    echo "Build with UCX/UCC support"
    build_with_ucx="--with-ucx=$PREFIX"
    build_with_ucc="--with-ucc=$PREFIX"
fi


# CUDA support
build_with_cuda=""
if [[ -n "$CUDA_HOME" ]]; then
    echo "Build with CUDA support"
    build_with_cuda="--with-cuda=$CUDA_HOME --with-cuda-libdir=$CUDA_HOME/lib64/stubs"
fi

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
    #
    # To regenerate the `cross-gfortran.*.sh` files follow these steps:
    #
    # * Create and activate a conda environment with `gcc=X.Y gfortran`
    #   packages and any other package required to configure openmpi.
    #   $ conda create -n ompi-config gcc=X.Y gfortran
    #   $ conda activate ompi-config
    #
    # * Run openmpi's `./configure` script
    #   $ tar -xf openmpi-X.Y.Z.tar.bz2
    #   $ cd openmpi-X.Y.Z
    #   $ ./configure
    #
    # * Use `grep` to get configure variables out of `config.log`:
    #   $ grep ompi_cv_fortran_ config.log | sed 's/^/export /' >> cross-gfortran.$target_arch.sh
    #   $ grep ompi_cv_real16_  config.log | sed 's/^/export /' >> cross-gfortran.$target_arch.sh
    #
    source $RECIPE_DIR/cross-gfortran.$target_platform.sh
fi

# disable wrapper-runpath for consistency with conda-forge wrt dtags
# openmpi's runpath adds new dtags to compiler wrappers
./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --disable-wrapper-runpath \
            --enable-mpi-fortran \
            --with-mpi-moduledir='${includedir}' \
            --with-wrapper-ldflags="${wrapper_ldflags}" \
            --with-sge \
            --with-hwloc=$PREFIX \
            --with-libevent=$PREFIX \
            --with-zlib=$PREFIX \
            --enable-mca-dso \
            --enable-ipv6 \
            $build_with_ucx \
            $build_with_ucc \
            $build_with_cuda \
    || (cat config.log; false)

make -j"${CPU_COUNT:-1}"
make install

POST_LINK=$PREFIX/bin/.openmpi-post-link.sh
if [ -n "$build_with_ucx" ]; then
    echo "setting MCA pml to ^ucx..."
    echo "pml = ^ucx" >> $PREFIX/etc/openmpi-mca-params.conf
    echo "setting MCA osc to ^ucx..."
    echo "osc = ^ucx" >> $PREFIX/etc/openmpi-mca-params.conf
    cat $RECIPE_DIR/post-link-ucx.sh >> $POST_LINK
fi
if [ -n "$build_with_ucc" ]; then
    echo "setting MCA coll_ucc_enable to 0..."
    echo "coll_ucc_enable = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    cat $RECIPE_DIR/post-link-ucc.sh >> $POST_LINK
fi
if [ -n "$build_with_cuda" ]; then
    echo "setting MCA mca_base_component_show_load_errors to 0..."
    echo "mca_base_component_show_load_errors = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    echo "setting MCA opal_warn_on_missing_libcuda to 0..."
    echo "opal_warn_on_missing_libcuda = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    echo "setting MCA opal_cuda_support to 0..."
    echo "opal_cuda_support = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    cat $RECIPE_DIR/post-link-cuda.sh >> $POST_LINK
fi
if [ -f $POST_LINK ]; then
    chmod +x $POST_LINK
fi

mkdir -p $PREFIX/etc/conda/activate.d
cp -v $RECIPE_DIR/openmpi_activate.sh $PREFIX/etc/conda/activate.d/
