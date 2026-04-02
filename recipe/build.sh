set -ex

if [[ "${gpu_variant}" != "cuda" ]]; then
  export FORCE_CUDA=0
else
  # CUDA 13.x: dropped compute_50-61 (Maxwell/Pascal), min is 7.0 (Volta)
  export TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;9.0;10.0;10.3;12.0;12.1+PTX"

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