import ctypes
import sys
from pathlib import Path

import psutil

# load every `libmpi*` shared library
for libmpi in (Path(sys.prefix) / "lib").glob("libmpi*.so"):
    print(f"Loading {libmpi}")
    ctypes.CDLL(libmpi)

# check all loaded libraries
print("Listing all libraries loaded")
all_loaded = []
for m in psutil.Process().memory_maps():
    p = m.path
    if p.startswith('['):
        # not a real library
        continue
    print(p)
    if '.so' not in p:
        # don't include things that aren't shared libs
        continue
    all_loaded.append(p)

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
