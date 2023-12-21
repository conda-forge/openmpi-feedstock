#!/bin/bash

cat << EOF >> $PREFIX/.messages.txt

On Linux, Open MPI is built with UCX support but it is disabled by default.
To enable it, first install UCX (conda install -c conda-forge ucx).
Afterwards, set the environment variables
OMPI_MCA_pml=ucx OMPI_MCA_osc=ucx
before launching your MPI processes.
Equivalently, you can set the MCA parameters in the command line:
mpiexec --mca pml ucx --mca osc ucx ...

EOF
