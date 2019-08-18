#!/bin/bash
set -eu
rank=$OMPI_COMM_WORLD_RANK
size=$OMPI_COMM_WORLD_SIZE
printf "Hello, World! I am process %d of %d.\n" $rank $size
