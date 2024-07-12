set -ex

if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  # +PTX should go to the oldest arch. There's a modest runtime performance
  # hit for (unlisted) newer arches on doing this, but the benefit is wider
  # compatibility.
  if [[ ${cuda_compiler_version} == 11.2* ]]; then
      export TORCH_CUDA_ARCH_LIST="3.5+PTX;5.0;6.0;6.1;7.0;7.5;8.0;8.6"
  elif [[ ${cuda_compiler_version} == 11.8 ]]; then
      export TORCH_CUDA_ARCH_LIST="3.5+PTX;5.0;6.0;6.1;7.0;7.5;8.0;8.6;9.0"
      export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
  elif [[ ${cuda_compiler_version} == 12.0 ]]; then
      export TORCH_CUDA_ARCH_LIST="5.0+PTX;6.0;6.1;7.0;7.5;8.0;8.6;9.0"
      # $CUDA_HOME not set in CUDA 12.0. Using $PREFIX
      export CUDA_TOOLKIT_ROOT_DIR="${PREFIX}"
  else
      echo "unsupported cuda version. edit build.sh"
      exit 1
  fi
  export FORCE_CUDA=1
fi

# remove pyproject.toml
rm -f pyproject.toml

export TORCHVISION_INCLUDE="${PREFIX}/include/"
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
