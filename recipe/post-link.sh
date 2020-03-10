#!/bin/bash

echo " " >> $PREFIX/.messages.txt
echo "For Linux 64, Open MPI is built with CUDA awareness but this support is disabled by default." >> $PREFIX/.messages.txt
echo "To enable it, please set the environmental variable OMPI_MCA_opal_cuda_support=true before" >> $PREFIX/.messages.txt
echo "launching your MPI processes. Equivalently, you can set the MCA parameter in the command line:" >> $PREFIX/.messages.txt
echo "mpiexec --mca opal_cuda_support 1 ..." >> $PREFIX/.messages.txt
echo " " >> $PREFIX/.messages.txt
