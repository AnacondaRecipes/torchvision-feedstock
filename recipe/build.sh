set -ex

if [[ "${gpu_variant}" != "cuda" ]]; then
  export FORCE_CUDA=0
else
  if [[ ${cuda_compiler_version} == 12.[0-6] ]]; then
      export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
      # $CUDA_HOME not set in CUDA 12.0. Using $PREFIX
      export CUDA_TOOLKIT_ROOT_DIR="${PREFIX}"
  else
      # nvcc 12.8 and later should be exporting TORCH_CUDA_ARCH_LIST
      echo "TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}"
  fi

  export FORCE_CUDA=1
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
  # Fix wrong (build) architecture being set instead of host architecture
  CFLAGS="$(echo ${CFLAGS} | sed 's/ -march=[^ ]*//g' | sed 's/ -mcpu=[^ ]*//g' |sed 's/ -mtune=[^ ]*//g')"
  CXXFLAGS="$(echo ${CXXFLAGS} | sed 's/ -march=[^ ]*//g' | sed 's/ -mcpu=[^ ]*//g' |sed 's/ -mtune=[^ ]*//g')"
fi

if [[ "${gpu_variant}" == "metal" ]]; then
  export FORCE_MPS=1
fi

# remove pyproject.toml
rm -f pyproject.toml

# https://github.com/pytorch/vision/pull/8406/files#r1730151047
rm -rf torchvision/csrc/io/image/cpu/giflib

export TORCHVISION_USE_NVJPEG=${FORCE_CUDA}


export TORCHVISION_INCLUDE="${PREFIX}/include/"
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation