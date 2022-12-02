#!/bin/bash
set -ex

export OMPI_MCA_plm=isolated
export OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMPI_MCA_rmaps_base_oversubscribe=yes
MPIEXEC="${PWD}/mpiexec.sh"

pushd "tests"

if [[ $PKG_NAME == "openmpi" ]]; then
  command -v ompi_info
  ompi_info

  if [[ ! -z "$(conda list | grep ucx)" ]]; then
    echo "Improper UCX dependency!"
    exit 1
  fi
  if [[ ! -z "$(conda list | grep cudatoolkit)" ]]; then
    echo "Improper cuda dependency!"
    exit 1
  fi

  command -v mpiexec
  $MPIEXEC --help
  $MPIEXEC -n 4 ./helloworld.sh
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

  mpifort $FFLAGS $LDFLAGS helloworld.f -o helloworld1_f
  $MPIEXEC -n 4 ./helloworld1_f

  mpifort $FFLAGS $LDFLAGS helloworld.f90 -o helloworld1_f90
  $MPIEXEC -n 4 ./helloworld1_f90

  command -v mpif77
  mpif77 -show

  mpif77 $FFLAGS $LDFLAGS helloworld.f -o helloworld2_f
  $MPIEXEC -n 4 ./helloworld2_f

  command -v mpif90
  mpif90 -show

  mpif90 $FFLAGS $LDFLAGS helloworld.f90 -o helloworld2_f90
  $MPIEXEC -n 4 ./helloworld2_f90

fi

popd
