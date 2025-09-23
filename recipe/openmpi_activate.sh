# rattler-build sets PKG_NAME, not CONDA_BUILD in test env
# ref: https://github.com/prefix-dev/rattler-build/issues/1317
# since this is an activate script, it should run on all shells,
# though only the first `if` really needs to since conda builds are necessarily bash
if [ "${CONDA_BUILD:-}" = "1" ] || [ -n "${PKG_NAME:-}" ]; then
  echo "setting openmpi environment variables for conda-build"
  if [ "${CONDA_BUILD_CROSS_COMPILATION:-}" = "1" ]; then
    # set compilation variables during cross compilation
    if [ -z "${OMPI_CC:-}" ] && [ -n "${CC:-}" ]; then
      echo "OMPI_CC=${CC}"
      export "OMPI_CC=${CC}"
    fi

    if [ -z "${OMPI_CXX:-}" ] && [ -n "${CXX:-}" ]; then
      echo "OMPI_CXX=${CXX}"
      export "OMPI_CXX=${CXX}"
    fi

    if [ -z "${OMPI_FC:-}" ] && [ -n "${FC:-}" ]; then
      echo "OMPI_FC=${FC}"
      export "OMPI_FC=${FC}"
    fi

    # require pkg-config?
    if [ -z "${OMPI_CFLAGS:-}" ]; then
      # pkg-config --cflags ompi
      export OMPI_CFLAGS="-I$PREFIX/include"
    fi
    if [ -z "${OMPI_CXXFLAGS:-}" ]; then
      # pkg-config --cflags ompi-cxx
      export OMPI_CXXFLAGS="-I$PREFIX/include"
    fi
    if [ -z "${OMPI_FCFLAGS:-}" ]; then
      # pkg-config --cflags ompi-fort
      export OMPI_FCFLAGS="-I$PREFIX/include"
    fi
    if [ -z "${OMPI_LDFLAGS:-}" ]; then
      # pkg-config --libs-only-L --libs-only-other ompi
      export OMPI_LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"
      case "${target_platform:-}" in
        linux-*)
          export OMPI_LDFLAGS="${OMPI_LDFLAGS} -Wl,--allow-shlib-undefined"
          ;;
      esac
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
