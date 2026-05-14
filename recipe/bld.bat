@echo On

if "%gpu_variant%" neq "cuda" (
  set FORCE_CUDA=0
) else (
  set FORCE_CUDA=1
  :: Point to build env's CUDA (nvcc is in build env, not host env)
  :: Also prevents cmake from finding system CUDA headers (version mismatch)
  set CUDA_HOME=%BUILD_PREFIX%\Library
  set CUDA_PATH=%BUILD_PREFIX%\Library
  :: Match pytorch-feedstock's CUDA arch list (libtorch ABI alignment); same for 12.9 and 13.0 on win-64 (x86_64 only)
  set TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0;10.0;12.0+PTX
)
set TORCHVISION_USE_NVJPEG=%FORCE_CUDA%

set TORCHVISION_INCLUDE=%LIBRARY_INC%
:: point the build system towards the .lib files and CUDA libs from host env
:: CUDA 13.x installs .lib files to Library\lib\x64 (changed from Library\lib in 12.x)
if "%cuda_compiler_version:~0,2%" == "13" (
  set LIB=%PREFIX%\\Lib\\site-packages\\torch\\lib;%LIBRARY_LIB%;%LIBRARY_PREFIX%\lib\x64;%LIB%
) else (
  set LIB=%PREFIX%\\Lib\\site-packages\\torch\\lib;%LIBRARY_LIB%;%LIB%
)
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
