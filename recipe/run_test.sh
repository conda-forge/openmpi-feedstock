#!/bin/bash

command -v ompi_info
ompi_info

command -v mpicc
mpicc -show

command -v mpicxx
mpicxx -show

command -v mpif90
mpif90 -show

command -v mpiexec
MPIEXEC="mpiexec -mca plm isolated --allow-run-as-root"
$MPIEXEC --help

pushd $RECIPE_DIR/tests

mpicc helloworld.c -o helloworld_c
$MPIEXEC -n 4 ./helloworld_c

mpicxx helloworld.cxx -o helloworld_cxx
$MPIEXEC -n 4 ./helloworld_cxx

mpif77 helloworld.f -o helloworld_f
$MPIEXEC -n 4 ./helloworld_f

mpif90 helloworld.f90 -o helloworld_f90
$MPIEXEC -n 4 ./helloworld_f90

popd
