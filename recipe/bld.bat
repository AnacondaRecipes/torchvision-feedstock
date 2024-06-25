@echo On

set TORCHVISION_INCLUDE=%LIBRARY_INC%
:: point the build system towards the .lib files
set TORCHVISION_LIBRARY=%PREFIX%\\Lib\\site-packages\\torch\\lib
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
