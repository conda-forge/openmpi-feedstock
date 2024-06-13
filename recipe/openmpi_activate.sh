if [ "${CONDA_BUILD:-}" = "1" ]; then
  echo "setting openmpi environment variables for conda-build"
  # build-time variables
  for _var in CC CXX FC CPPFLAGS CFLAGS CXXFLAGS FCFLAGS LDFLAGS; do
    _var_val=$(eval echo \$\{${_var}:-\})
    if [ ! -z "${_var_val}" ]; then
      echo "OMPI_${_var}=${_var_val}"
      export OMPI_${_var}="${_var_val}"
    fi
  done
  if [ -z "${OMPI_FCFLAGS}" && ! -z "${FFLAGS}" ]; then
    echo OMPI_FCFLAGS="-I$PREFIX/include $FFLAGS"
    export OMPI_FCFLAGS="-I$PREFIX/include $FFLAGS"
  fi
  export OPAL_PREFIX="$PREFIX"

  # runtime variables
  export OMPI_MCA_plm_ssh_agent=false
  export OMPI_MCA_pml=ob1
  export OMPI_MCA_mpi_yield_when_idle=true
  export OMPI_MCA_btl_base_warn_component_unused=false
  export PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe
fi
