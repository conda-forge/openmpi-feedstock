if [[ "${CONDA_BUILD:-}" = "1" ]]; then
  echo "setting openmpi environment variables for conda-build"
  # build-time variables
  for _var in CC CXX FC CPPFLAGS CFLAGS CXXFLAGS FCFLAGS LDFLAGS; do
    if [[ ! -z "${!_var:-}" ]]; then
      echo "OMPI_${_var}=${!_var}"
      export OMPI_${_var}="${!_var}"
    fi
    if [[ -z "${OMPI_FCFLAGS}" && ! -z "${FFLAGS}" ]]; then
      export OMPI_FCFLAGS="$FFLAGS"
    fi
  done
  export OPAL_PREFIX="$PREFIX"

  # runtime variables
  export OMPI_MCA_plm_ssh_agent=false
  export OMPI_MCA_pml=ob1
  export OMPI_MCA_mpi_yield_when_idle=true
  export OMPI_MCA_btl_base_warn_component_unused=false
  export PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe
fi
