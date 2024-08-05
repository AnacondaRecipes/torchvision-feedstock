@echo On

set TORCHVISION_INCLUDE=%LIBRARY_INC%
:: point the build system towards the .lib files
set LIB=%PREFIX%\\Lib\\site-packages\\torch\\lib;%LIB%
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
