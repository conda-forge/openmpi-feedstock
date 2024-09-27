#!/bin/bash

cat << EOF >> $PREFIX/.messages.txt

On Linux, Open MPI is built with UCC support but it is disabled by default.
To enable it, first install UCC (conda install -c conda-forge ucc).
Afterwards, set the environment variables
OMPI_MCA_coll_ucc_enable=1
before launching your MPI processes.
Equivalently, you can set the MCA parameters in the command line:
mpiexec --mca coll_ucc_enable 1 ...

EOF
