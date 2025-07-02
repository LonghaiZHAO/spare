@echo off
echo ========================================
echo SPARE Windows Build Script
echo ========================================
echo.

REM Check if vcpkg is available
where vcpkg >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Warning: vcpkg not found in PATH
    echo Please install vcpkg and add it to your PATH, or specify VCPKG_ROOT
    echo.
)

REM Set default vcpkg root if not specified
if "%VCPKG_ROOT%"=="" (
    set VCPKG_ROOT=C:\vcpkg
)

echo Using vcpkg root: %VCPKG_ROOT%
echo.

REM Check if vcpkg exists
if not exist "%VCPKG_ROOT%\vcpkg.exe" (
    echo Error: vcpkg not found at %VCPKG_ROOT%
    echo Please install vcpkg or set VCPKG_ROOT environment variable
    echo.
    echo To install vcpkg:
    echo   git clone https://github.com/Microsoft/vcpkg.git
    echo   cd vcpkg
    echo   .\bootstrap-vcpkg.bat
    echo   .\vcpkg integrate install
    echo.
    pause
    exit /b 1
)

echo Step 1: Installing dependencies with vcpkg...
echo.

REM Install dependencies
echo Installing Eigen3...
"%VCPKG_ROOT%\vcpkg.exe" install eigen3:x64-windows
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to install Eigen3
    pause
    exit /b 1
)

echo Installing OpenMesh...
"%VCPKG_ROOT%\vcpkg.exe" install openmesh:x64-windows
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to install OpenMesh
    pause
    exit /b 1
)

echo.
echo Step 2: Creating build directory...
if not exist "build" mkdir build
cd build

echo.
echo Step 3: Configuring CMake...
cmake .. -DCMAKE_TOOLCHAIN_FILE="%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" -DCMAKE_BUILD_TYPE=Release -A x64
if %ERRORLEVEL% NEQ 0 (
    echo Error: CMake configuration failed
    pause
    exit /b 1
)

echo.
echo Step 4: Building project...
cmake --build . --config Release
if %ERRORLEVEL% NEQ 0 (
    echo Error: Build failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Executable location: build\Release\spare.exe
echo.
echo To test the build:
echo   cd build\Release
echo   spare.exe --help
echo.
pause