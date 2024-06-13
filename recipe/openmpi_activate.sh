if [ "${CONDA_BUILD:-}" = "1" ]; then
  echo "setting openmpi environment variables for conda-build"
  if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" = "1" ]]; then
    # set compilation variables during cross compilation
    for _var in CC CXX FC; do
      if [[ ! -z "${!_var:-}" ]]; then
        echo "OMPI_${_var}=${!_var}"
        export OMPI_${_var}="${!_var}"
      fi
    done
    # require pkg-config?
    if [[ -z "${OMPI_CFLAGS:-}" ]]; then
      # pkg-config --cflags ompi
      export OMPI_CFLAGS="-I$PREFIX/include"
    fi
    if [[ -z "${OMPI_CXXFLAGS:-}" ]]; then
      # pkg-config --cflags ompi-cxx
      export OMPI_CXXFLAGS="-I$PREFIX/include"
    fi
    if [[ -z "${OMPI_FCFLAGS:-}" ]]; then
      # pkg-config --cflags ompi-fort
      export OMPI_FCFLAGS="-I$PREFIX/include"
    fi
    if [[ -z "${OMPI_LDFLAGS:-}" ]]; then
      # pkg-config --libs-only-L --libs-only-other ompi
      export OMPI_LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"
      if [[ "${target_platform:-}" == linux-* ]]; then
        export OMPI_LDFLAGS="${OMPI_LDFLAGS} -Wl,--allow-shlib-undefined"
      fi
    fi
    export OPAL_PREFIX="$PREFIX"
  fi

  # runtime variables
  export OMPI_MCA_plm_ssh_agent=false
  export OMPI_MCA_pml=ob1
  export OMPI_MCA_mpi_yield_when_idle=true
  export OMPI_MCA_btl_base_warn_component_unused=false
  export PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe
fi
