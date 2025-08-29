@echo off
REM CONFIG
set "BUILD_DIR=build"
set "OUT_DIR=%BUILD_DIR%\out"
set "BUILD_TYPE=Release"
set "DEV_CONSOLE=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"

REM ================= MAIN =================
call :enableDevConsole
call :initDirectories
call :checkTools
call :gitClone
call :detectIdaSdk
call :buildBinExport
call :buildBinDiff
echo.
echo [OK] Build completed. Plugins are in %OUT_DIR%.
pause
goto :eof

REM ================= FUNCTIONS =================

:enableDevConsole
echo Switching to Visual Studio 2022 Devconsole (x64)...
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
if errorlevel 1 (
    echo vcvarsall.bat failed! Make sure Visual Studio 2022 is installed.
    exit /b 1
)
goto :eof

:initDirectories
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%BUILD_DIR%\idasdk" mkdir "%BUILD_DIR%\idasdk"
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"
goto :eof

:checkTools
where git >nul 2>&1 || (echo [ERROR] Git not found! & exit /b 1)
echo Git found.

where cmake >nul 2>&1 || (echo [ERROR] CMake not found! & exit /b 1)
echo CMake found.

where ninja >nul 2>&1 || (echo [ERROR] Ninja not found! & exit /b 1)
echo Ninja found.

goto :eof

:gitClone
if not exist "%BUILD_DIR%\binexport" (
    git clone https://github.com/google/binexport "%BUILD_DIR%\binexport"
) else (
    echo BinExport already cloned.
)

if not exist "%BUILD_DIR%\bindiff" (
    git clone https://github.com/google/bindiff "%BUILD_DIR%\bindiff"
) else (
    echo BinDiff already cloned.
)
goto :eof

:detectIdaSdk
echo Searching IDA SDK in %BUILD_DIR%\idasdk ...
for /d %%I in ("%BUILD_DIR%\idasdk\*") do (
    set "IDA_SDK=%%~fI"
    echo Found IDA SDK at: %%~fI
    goto :eof
)
echo No IDA SDK found in %BUILD_DIR%\idasdk !
pause
exit

:foundSdk
echo Found IDA SDK at: %IDA_SDK%
goto :eof

:buildBinExport
echo.
echo [BUILD] BinExport...
cmake -S "%BUILD_DIR%\binexport" -B "%OUT_DIR%\binexport" -G Ninja ^
  -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
  -DCMAKE_INSTALL_PREFIX="%OUT_DIR%\binexport" ^
  -DIdaSdk_ROOT_DIR="%IDA_SDK%" ^
  -DBINEXPORT_ENABLE_IDAPRO=ON

cmake --build "%OUT_DIR%\binexport"
goto :eof

:buildBinDiff
echo.
echo [BUILD] BinDiff...
cmake -S "%BUILD_DIR%\bindiff" -B "%OUT_DIR%\bindiff" -G Ninja ^
  -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
  -DCMAKE_INSTALL_PREFIX="%OUT_DIR%\bindiff" ^
  -DBINDIFF_BINEXPORT_DIR="%BUILD_DIR%\binexport" ^
  -DIdaSdk_ROOT_DIR="%IDA_SDK%" ^
  -DBINEXPORT_ENABLE_IDAPRO=ON

cmake --build "%OUT_DIR%\bindiff"
goto :eof
