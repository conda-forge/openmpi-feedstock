#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  export DYLD_LIBRARY_PATH=$PREFIX/lib
fi

command -v ompi_info
ompi_info

command -v mpirun
mpirun --allow-run-as-root --help

command -v mpicc
mpicc --allow-run-as-root -show

command -v mpicxx
mpicxx --allow-run-as-root -show

command -v mpif90
mpif90 --allow-run-as-root -show

command -v mpiexec

mpicc $RECIPE_DIR/tests/helloworld.c -o helloworld_c
mpiexec -mca plm isolated --allow-run-as-root -n 4 helloworld_c

mpicxx $RECIPE_DIR/tests/helloworld.cxx -o helloworld_cxx
mpiexec -mca plm isolated --allow-run-as-root -n 4 helloworld_cxx

mpif90 $RECIPE_DIR/tests/helloworld.f90 -o helloworld_f90
mpiexec -mca plm isolated --allow-run-as-root -n 4 helloworld_f90

