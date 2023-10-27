#!/bin/bash
set -ex

export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=sm,self
export OMPI_MCA_plm_ssh_agent=false
export OMPI_MCA_rmaps_default_mapping_policy=:oversubscribe
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
MPIEXEC="mpiexec"

pushd "tests"

if [[ $PKG_NAME == "openmpi" ]]; then

  if [[ -n "$(conda list | grep ucx)" ]]; then
    echo "Improper UCX dependency!"
    exit 1
  fi

  if [[ -n "$(conda list | grep cuda-version)" ]]; then
    echo "Improper CUDA dependency!"
    exit 1
  fi

  command -v ompi_info
  ompi_info

  command -v prte_info
  prte_info

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
