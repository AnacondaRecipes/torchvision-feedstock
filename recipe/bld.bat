@echo On

set TORCHVISION_INCLUDE=%LIBRARY_INC%
:: point the build system towards the .lib files
:: set TORCHVISION_LIBRARY=%PREFIX%\\Lib\\site-packages\\torch\\lib
set LIB=%PREFIX%\\Lib\\site-packages\\torch\\lib;%LIB%
set CMAKE_LIBRARY_PATH=%PREFIX%\\Lib\\site-packages\\torch\\lib;%CMAKE_LIBRARY_PATH%
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
