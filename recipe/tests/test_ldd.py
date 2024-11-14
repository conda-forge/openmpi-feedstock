import ctypes
import os
import sys
from pathlib import Path

# load every `libmpi*` shared library
mpi_libs = []
for libmpi in (Path(sys.prefix) / "lib").glob("libmpi*.so"):
    print(f"Loading {libmpi}")
    mpi_libs.append(ctypes.CDLL(libmpi))

# check all loaded libraries
print("Listing all libraries loaded")
# psutil.Process.memory_maps() doesn't work in emulated builds,
# use procfs ourselves
all_loaded = set()
with open(f"/proc/{os.getpid()}/maps") as f:
    for line in f.readlines():
        line = line.strip()
        if not line:
            continue
        chunks = line.split(None, 5)
        if len(chunks) <= 5:
            continue
        path = chunks[-1]
        if path.startswith('['):
            # not a real library
            continue
        print(path)
        if '.so' not in path:
            # don't include things that aren't shared libs
            continue
        all_loaded.add(path)

allowed_prefixes = ("/usr/lib", "/usr/lib64", sys.prefix)
print(f"Checking for libraries loaded outside {allowed_prefixes}")
for p in all_loaded:
    if not p.startswith(sys.prefix + "/"):
        print(p)
    # make sure we don't load anything outside the env
    # the main thing we are looking for is cuda, which is installed in /usr/local/cuda...
    assert p.startswith(allowed_prefixes), p
    # make sure we don't load any cuda libs
    assert 'cudart' not in p, p
    assert 'libcuda' not in p, p
