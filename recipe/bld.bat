@echo On

if "%gpu_variant%" neq "cuda" (
  set FORCE_CUDA=0
) else (
  set FORCE_CUDA=1
  :: pytorch 2.9.1 doesn't support arch 10.1 exported by nvcc 12.8+
  set TORCH_CUDA_ARCH_LIST=5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0;10.0+PTX
)
set TORCHVISION_USE_NVJPEG=%FORCE_CUDA%

set TORCHVISION_INCLUDE=%LIBRARY_INC%
:: point the build system towards the .lib files
set LIB=%PREFIX%\\Lib\\site-packages\\torch\\lib;%LIB%
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
