#!/bin/bash

echo " " >> $PREFIX/.messages.txt
echo "For Linux 64, Open MPI is built with CUDA awareness but this support is disabled by default." >> $PREFIX/.messages.txt
echo "To enable it, please set the environment variable OMPI_MCA_opal_cuda_support=true before" >> $PREFIX/.messages.txt
echo "launching your MPI processes. Equivalently, you can set the MCA parameter in the command line:" >> $PREFIX/.messages.txt
echo "mpiexec --mca opal_cuda_support 1 ..." >> $PREFIX/.messages.txt
echo " " >> $PREFIX/.messages.txt

echo "In addition, the UCX support is also built but disabled by default." >> $PREFIX/.messages.txt
echo "To enable it, first install UCX (conda install -c conda-forge ucx). Then, set the environment" >> $PREFIX/.messages.txt
echo "variables OMPI_MCA_pml=\"ucx\" OMPI_MCA_osc=\"ucx\" before launching your MPI processes." >> $PREFIX/.messages.txt
echo "Equivalently, you can set the MCA parameters in the command line:" >> $PREFIX/.messages.txt
echo "mpiexec --mca pml ucx --mca osc ucx ..." >> $PREFIX/.messages.txt
echo "Note that you might also need to set UCX_MEMTYPE_CACHE=n for CUDA awareness via UCX." >> $PREFIX/.messages.txt
echo "Please consult UCX's documentation for detail." >> $PREFIX/.messages.txt
echo " " >> $PREFIX/.messages.txt
