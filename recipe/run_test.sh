#!/bin/bash
set -e

command -v ompi_info
ompi_info

command -v mpicc
mpicc -show

command -v mpicxx
mpicxx -show

command -v mpifort
mpifort -show

command -v mpif90
mpif90 -show

command -v mpif77
mpif77 -show

export OMPI_MCA_plm=isolated
export OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMPI_MCA_rmaps_base_oversubscribe=yes

command -v mpiexec
MPIEXEC="${RECIPE_DIR}/mpiexec.sh"
$MPIEXEC --help

pushd $RECIPE_DIR/tests

mpicc helloworld.c -o helloworld_c
$MPIEXEC -n 4 ./helloworld_c

mpicxx helloworld.cxx -o helloworld_cxx
$MPIEXEC -n 4 ./helloworld_cxx

mpif90 helloworld.f90 -o helloworld_f90
$MPIEXEC -n 4 ./helloworld_f90

mpif77 helloworld.f -o helloworld_f
$MPIEXEC -n 4 ./helloworld_f

popd
