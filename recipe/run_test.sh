#!/bin/bash
set -ex

MPIEXEC="mpiexec"

pushd "tests"

if [[ $PKG_NAME == "openmpi" ]]; then

  if [[ "$target_platform" == linux-64 || "$target_platform" == linux-aarch64 ]]; then
    if [[ -z "$(ompi_info | grep ucc)" ]]; then
      echo "OpenMPI configured without UCC support!"
      exit 1
    fi
    if [[ -z "$(ompi_info | grep ucx)" ]]; then
      echo "OpenMPI configured without UCX support!"
      exit 1
    fi
  fi

  if [[ -n "$(conda list | grep cuda-version)" ]]; then
    echo "Improper CUDA dependency!"
    exit 1
  fi

  if [[ "$target_platform" == linux-64 || "$target_platform" == linux-aarch64 ]]; then
    if [[ -z "$(ompi_info | grep cuda)" ]]; then
      echo "OpenMPI configured without CUDA support!"
      exit 1
    fi
  fi

  command -v ompi_info
  ompi_info

  command -v prte_info
  prte_info

  command -v mpiexec
  $MPIEXEC --help
  $MPIEXEC -n 4 ./helloworld.sh

  test -f $PREFIX/include/mpi.mod

  export MPIEXEC_TIMEOUT=1

  if $MPIEXEC -n 2 sleep 5; then
    echo "should have timed out"
    exit 1
  fi
fi

if [[ $PKG_NAME == "openmpi-mpicc" ]]; then
  command -v mpicc
  mpicc -show

  env | grep OMPI

  test -z "${OMPI_CC:-}"
  test -z "${OMPI_CFLAGS:-}"
  test -z "${OMPI_CPPFLAGS:-}"
  test -z "${OMPI_LDFLAGS:-}"

  mpicc helloworld.c -o helloworld_c
  $MPIEXEC -n 4 ./helloworld_c
fi

if [[ $PKG_NAME == "openmpi-mpicxx" ]]; then
  command -v mpicxx
  mpicxx -show

  test -z "${OMPI_CXX:-}"
  test -z "${OMPI_CXXFLAGS:-}"

  mpicxx helloworld.cxx -o helloworld_cxx
  $MPIEXEC -n 4 ./helloworld_cxx
fi

if [[ $PKG_NAME == "openmpi-mpifort" ]]; then
  command -v mpifort
  mpifort -show
  
  test -z "${OMPI_FC:-}"
  test -z "${OMPI_FCFLAGS:-}"

  mpifort helloworld.f -o helloworld1_f
  $MPIEXEC -n 4 ./helloworld1_f

  mpifort helloworld.f90 -o helloworld1_f90
  $MPIEXEC -n 4 ./helloworld1_f90

  command -v mpif77
  mpif77 -show

  mpif77 helloworld.f -o helloworld2_f
  $MPIEXEC -n 4 ./helloworld2_f

  command -v mpif90
  mpif90 -show

  mpif90 helloworld.f90 -o helloworld2_f90
  $MPIEXEC -n 4 ./helloworld2_f90

fi

popd
