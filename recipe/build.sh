set -ex

if [[ "${gpu_variant}" != "cuda" ]]; then
  export FORCE_CUDA=0
else
  # Match pytorch-feedstock's CUDA arch list (libtorch ABI alignment with pytorch on pkgs/main)
  if [[ "$(uname -m)" == "aarch64" ]]; then
    # aarch64 CUDA 13: includes sm_11.0 (Grace-Hopper) and sm_12.1+PTX (Blackwell DGX Spark)
    export TORCH_CUDA_ARCH_LIST="8.0;9.0;10.0;11.0;12.0;12.1+PTX"
  else
    # x86_64 CUDA 12.x / 13.x: same list (12.0+PTX for Blackwell forward-compat)
    export TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;9.0;10.0;12.0+PTX"
  fi
  export FORCE_CUDA=1
  # CUDA 12.x requires gcc <14.0 per torch/utils/cpp_extension.py CUDA_GCC_VERSIONS,
  # but pkgs/main only ships gcc 14.3.0 — same gcc that built pytorch 2.11. Bypass
  # the consumer-side check; the libstdc++ ABI is consistent.
  if [[ "${cuda_compiler_version:0:2}" == "12" ]]; then
    export TORCH_DONT_CHECK_COMPILER_ABI=1
  fi
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
