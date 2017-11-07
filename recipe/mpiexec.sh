#!/bin/bash
set -e
# pipe stdout, stderr through cat to avoid O_NONBLOCK issues
mpiexec --allow-run-as-root $@ 2>&1</dev/null | cat
