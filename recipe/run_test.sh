#!/bin/bash
set -ex

export OMPI_MCA_plm=isolated
export OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMPI_MCA_rmaps_base_oversubscribe=yes

command -v mpiexec
MPIEXEC="${PWD}/mpiexec.sh"

pushd "tests"

if [[ $PKG_NAME == "openmpi" ]]; then
  command -v ompi_info
  ompi_info

  $MPIEXEC --help

  $MPIEXEC -n 4 python test_exec.py
fi

if [[ $PKG_NAME == "openmpi-mpicc" ]]; then
  command -v mpicc
  mpicc -show

  mpicc $CFLAGS $LDFLAGS helloworld.c -o helloworld_c
  $MPIEXEC -n 4 ./helloworld_c
fi

if [[ $PKG_NAME == "openmpi-mpicxx" ]]; then
  command -v mpicxx
  mpicxx -show

  mpicxx $CXXFLAGS $LDFLAGS helloworld.cxx -o helloworld_cxx
  $MPIEXEC -n 4 ./helloworld_cxx
fi

if [[ $PKG_NAME == "openmpi-mpifort" ]]; then

  command -v mpifort
  mpifort -show

  command -v mpif90
  mpif90 -show

  command -v mpif77
  mpif77 -show

  mpif77 $FFLAGS $LDFLAGS helloworld.f -o helloworld_f
  $MPIEXEC -n 4 ./helloworld_f

  mpif90 $FFLAGS $LDFLAGS helloworld.f90 -o helloworld_f90
  $MPIEXEC -n 4 ./helloworld_f90

  mpifort $FFLAGS $LDFLAGS helloworld.f90 -o helloworld_fort
  $MPIEXEC -n 4 ./helloworld_fort
fi

popd
