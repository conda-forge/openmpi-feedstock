#!/bin/bash

set -ex

# avoid absolute-paths in compilers
export CC=$(basename "$CC")
export CXX=$(basename "$CXX")
export FC=$(basename "$FC")

# unset unused Fortran compiler variables
unset FFLAGS F77 F90 F95

# tweak compiler flags
export LIBRARY_PATH="$PREFIX/lib"
if [[ "$target_platform" == osx-* ]]; then
    if [[ -n "$CONDA_BUILD_SYSROOT" ]]; then
        export CFLAGS="$CFLAGS -isysroot $CONDA_BUILD_SYSROOT"
        export CXXFLAGS="$CXXFLAGS -isysroot $CONDA_BUILD_SYSROOT"
    fi
fi

# UCX support
build_with_ucx=""
if [[ "$target_platform" == linux-* ]]; then
    build_with_ucx="--with-ucx=$PREFIX"
fi

# CUDA support
build_with_cuda=""
if [[ -n "$CUDA_HOME" ]]; then
    build_with_cuda="--with-cuda=yes"
    export CFLAGS="$CFLAGS -I$CUDA_HOME/include"
    export CXXFLAGS="$CXXFLAGS -I$CUDA_HOME/include"
    export LDFLAGS="$LDFLAGS -L$CUDA_HOME/lib64/stubs"
fi

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1"  && $target_platform == osx-arm64 ]]; then
    export ompi_cv_fortran_abstract=yes
    export ompi_cv_fortran_alignment_CHARACTER=1
    export ompi_cv_fortran_alignment_COMPLEX=4
    export ompi_cv_fortran_alignment_COMPLEXp16=8
    export ompi_cv_fortran_alignment_COMPLEXp8=4
    export ompi_cv_fortran_alignment_DOUBLE_COMPLEX=8
    export ompi_cv_fortran_alignment_DOUBLE_PRECISION=8
    export ompi_cv_fortran_alignment_INTEGER=4
    export ompi_cv_fortran_alignment_INTEGERp1=1
    export ompi_cv_fortran_alignment_INTEGERp2=2
    export ompi_cv_fortran_alignment_INTEGERp4=4
    export ompi_cv_fortran_alignment_INTEGERp8=8
    export ompi_cv_fortran_alignment_LOGICAL=4
    export ompi_cv_fortran_alignment_LOGICALp1=1
    export ompi_cv_fortran_alignment_LOGICALp2=2
    export ompi_cv_fortran_alignment_LOGICALp4=4
    export ompi_cv_fortran_alignment_LOGICALp8=8
    export ompi_cv_fortran_alignment_REAL=4
    export ompi_cv_fortran_alignment_REALp4=4
    export ompi_cv_fortran_alignment_REALp8=8
    export ompi_cv_fortran_alignment_type_test_mpi_handle_='    8'
    export ompi_cv_fortran_asynchronous=yes
    export ompi_cv_fortran_c_funloc=yes
    export ompi_cv_fortran_external_symbol='single underscore'
    export ompi_cv_fortran_f08_assumed_rank=yes
    export ompi_cv_fortran_handle_max=2147483647
    export ompi_cv_fortran_have_CHARACTER=yes
    export ompi_cv_fortran_have_COMPLEX=yes
    export ompi_cv_fortran_have_COMPLEXp16=yes
    export ompi_cv_fortran_have_COMPLEXp32=no
    export ompi_cv_fortran_have_COMPLEXp4=no
    export ompi_cv_fortran_have_COMPLEXp8=yes
    export ompi_cv_fortran_have_DOUBLE_COMPLEX=yes
    export ompi_cv_fortran_have_DOUBLE_PRECISION=yes
    export ompi_cv_fortran_have_INTEGER=yes
    export ompi_cv_fortran_have_INTEGERp16=yes
    export ompi_cv_fortran_have_INTEGERp1=yes
    export ompi_cv_fortran_have_INTEGERp2=yes
    export ompi_cv_fortran_have_INTEGERp4=yes
    export ompi_cv_fortran_have_INTEGERp8=yes
    export ompi_cv_fortran_have_LOGICAL=yes
    export ompi_cv_fortran_have_LOGICALp1=yes
    export ompi_cv_fortran_have_LOGICALp2=yes
    export ompi_cv_fortran_have_LOGICALp4=yes
    export ompi_cv_fortran_have_LOGICALp8=yes
    export ompi_cv_fortran_have_REAL=yes
    export ompi_cv_fortran_have_REALp16=no
    export ompi_cv_fortran_have_REALp2=no
    export ompi_cv_fortran_have_REALp4=yes
    export ompi_cv_fortran_have_REALp8=yes
    export ompi_cv_fortran_have_bind_c_sub=yes
    export ompi_cv_fortran_have_bind_c_type=yes
    export ompi_cv_fortran_have_bind_c_type_name=yes
    export ompi_cv_fortran_have_iso_c_binding=yes
    export ompi_cv_fortran_have_iso_fortran_env=yes
    export ompi_cv_fortran_have_storage_size=yes
    export ompi_cv_fortran_ignore_tkr_data='1:type(*), dimension(*):!GCC$ ATTRIBUTES NO_ARG_CHECK ::'
    export ompi_cv_fortran_interface=yes
    export ompi_cv_fortran_kind_value_0=0
    export ompi_cv_fortran_kind_value_C_DOUBLE=8
    export ompi_cv_fortran_kind_value_C_DOUBLE_COMPLEX=8
    export ompi_cv_fortran_kind_value_C_FLOAT=4
    export ompi_cv_fortran_kind_value_C_FLOAT_COMPLEX=4
    export ompi_cv_fortran_kind_value_C_INT16_T=2
    export ompi_cv_fortran_kind_value_C_INT32_T=4
    export ompi_cv_fortran_kind_value_C_INT64_T=8
    export ompi_cv_fortran_kind_value_C_INT=4
    export ompi_cv_fortran_kind_value_C_LONG_LONG=8
    export ompi_cv_fortran_kind_value_C_SHORT=2
    export ompi_cv_fortran_kind_value_C_SIGNED_CHAR=1
    export ompi_cv_fortran_logical_array_correct=yes
    export ompi_cv_fortran_max_array_rank=15
    export ompi_cv_fortran_module_include_flag=-I
    export ompi_cv_fortran_optional=yes
    export ompi_cv_fortran_private=yes
    export ompi_cv_fortran_procedure=yes
    export ompi_cv_fortran_protected=yes
    export ompi_cv_fortran_sizeof_CHARACTER=1
    export ompi_cv_fortran_sizeof_COMPLEX=8
    export ompi_cv_fortran_sizeof_COMPLEXp16=16
    export ompi_cv_fortran_sizeof_COMPLEXp8=8
    export ompi_cv_fortran_sizeof_DOUBLE_COMPLEX=16
    export ompi_cv_fortran_sizeof_DOUBLE_PRECISION=8
    export ompi_cv_fortran_sizeof_INTEGER=4
    export ompi_cv_fortran_sizeof_INTEGERp16=16
    export ompi_cv_fortran_sizeof_INTEGERp1=1
    export ompi_cv_fortran_sizeof_INTEGERp2=2
    export ompi_cv_fortran_sizeof_INTEGERp4=4
    export ompi_cv_fortran_sizeof_INTEGERp8=8
    export ompi_cv_fortran_sizeof_LOGICAL=4
    export ompi_cv_fortran_sizeof_LOGICALp1=1
    export ompi_cv_fortran_sizeof_LOGICALp2=2
    export ompi_cv_fortran_sizeof_LOGICALp4=4
    export ompi_cv_fortran_sizeof_LOGICALp8=8
    export ompi_cv_fortran_sizeof_REAL=4
    export ompi_cv_fortran_sizeof_REALp4=4
    export ompi_cv_fortran_sizeof_REALp8=8
    export ompi_cv_fortran_sizeof_type_test_mpi_handle_=4
    export ompi_cv_fortran_true_value=1
    export ompi_cv_fortran_use_only=yes
fi

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
            --with-hwloc=$PREFIX \
            --with-libevent=$PREFIX \
            --with-zlib=$PREFIX \
            --enable-mca-dso \
            $build_with_ucx \
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
if [ -n "$build_with_cuda" ]; then
    echo "setting MCA opal_warn_on_missing_libcuda to 0..."
    echo "opal_warn_on_missing_libcuda = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    echo "setting MCA opal_cuda_support to 0..."
    echo "opal_cuda_support = 0" >> $PREFIX/etc/openmpi-mca-params.conf
    cat $RECIPE_DIR/post-link-cuda.sh >> $POST_LINK
fi
if [ -f $POST_LINK ]; then
    chmod +x $POST_LINK
fi
