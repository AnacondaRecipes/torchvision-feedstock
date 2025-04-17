@echo On

if "%cuda_compiler_version%" == "None" (
  set FORCE_CUDA=0
) else (
  set FORCE_CUDA=1
)
set TORCHVISION_USE_NVJPEG=%FORCE_CUDA%

set TORCHVISION_INCLUDE=%LIBRARY_INC%
:: point the build system towards the .lib files
set LIB=%PREFIX%\\Lib\\site-packages\\torch\\lib;%LIB%
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
