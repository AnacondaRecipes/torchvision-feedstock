@echo On

if "%gpu_variant%" neq "cuda" (
  set FORCE_CUDA=0
) else (
  set FORCE_CUDA=1
  :: Point to build env's CUDA (nvcc is in build env, not host env)
  :: Also prevents cmake from finding system CUDA headers (version mismatch)
  set "CUDA_HOME=%BUILD_PREFIX%\Library"
  set "CUDA_PATH=%BUILD_PREFIX%\Library"
  REM Match pytorch-feedstock's CUDA arch list for libtorch ABI alignment: same for 12.9 and 13.0 on win-64;
  REM win-arm64 CUDA 13.4 also has sm_12.1, the N1X / DGX Spark class
  set "TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0;10.0;12.0+PTX"
  if /i "%target_platform%"=="win-arm64" set "TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0;10.0;12.0;12.1+PTX"
)
set TORCHVISION_USE_NVJPEG=%FORCE_CUDA%

set "TORCHVISION_INCLUDE=%LIBRARY_INC%"
:: point the build system towards the .lib files and CUDA libs from host env
REM CUDA 13.x installs .lib files to Library\lib\x64 on win-64 and Library\lib\arm64 on win-arm64 (both added
REM unconditionally; a directory that doesn't exist on a platform or on 12.x is harmless)
set "LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIBRARY_LIB%;%LIBRARY_PREFIX%\lib\x64;%LIBRARY_PREFIX%\lib\arm64;%LIB%"

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
