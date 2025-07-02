@echo off
setlocal enabledelayedexpansion

echo ========================================
echo SPARE Windows Automatic Installer
echo ========================================
echo.
echo This script will:
echo 1. Check system requirements
echo 2. Install vcpkg (if needed)
echo 3. Install dependencies
echo 4. Build SPARE
echo 5. Run tests
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

REM Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: Git is not installed or not in PATH
    echo Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

REM Check if CMake is installed
where cmake >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: CMake is not installed or not in PATH
    echo Please install CMake from https://cmake.org/
    pause
    exit /b 1
)

REM Check if Visual Studio or Build Tools are available
where cl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Visual Studio compiler not found in PATH
    echo You may need to run this from a Visual Studio Developer Command Prompt
    echo Or install Visual Studio Build Tools
    echo.
    echo Continue anyway? (y/n)
    set /p choice=
    if /i not "!choice!"=="y" exit /b 1
)

echo.
echo Step 1: Setting up vcpkg...

REM Set vcpkg directory
set VCPKG_ROOT=C:\vcpkg

REM Check if vcpkg already exists
if exist "%VCPKG_ROOT%\vcpkg.exe" (
    echo vcpkg already installed at %VCPKG_ROOT%
) else (
    echo Installing vcpkg...
    if exist "%VCPKG_ROOT%" rmdir /s /q "%VCPKG_ROOT%"
    git clone https://github.com/Microsoft/vcpkg.git "%VCPKG_ROOT%"
    if %ERRORLEVEL% NEQ 0 (
        echo Error: Failed to clone vcpkg
        pause
        exit /b 1
    )
    
    cd /d "%VCPKG_ROOT%"
    call bootstrap-vcpkg.bat
    if %ERRORLEVEL% NEQ 0 (
        echo Error: Failed to bootstrap vcpkg
        pause
        exit /b 1
    )
    
    vcpkg integrate install
    if %ERRORLEVEL% NEQ 0 (
        echo Error: Failed to integrate vcpkg
        pause
        exit /b 1
    )
)

echo.
echo Step 2: Installing dependencies...

cd /d "%VCPKG_ROOT%"

echo Installing Eigen3...
vcpkg install eigen3:x64-windows
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to install Eigen3
    pause
    exit /b 1
)

echo Installing OpenMesh...
vcpkg install openmesh:x64-windows
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to install OpenMesh
    pause
    exit /b 1
)

echo.
echo Step 3: Building SPARE...

REM Go back to the project directory
cd /d "%~dp0"
cd ..

if not exist "win\build" mkdir "win\build"
cd "win\build"

echo Configuring CMake...
cmake .. -DCMAKE_TOOLCHAIN_FILE="%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" -DCMAKE_BUILD_TYPE=Release -A x64
if %ERRORLEVEL% NEQ 0 (
    echo Error: CMake configuration failed
    pause
    exit /b 1
)

echo Building project...
cmake --build . --config Release
if %ERRORLEVEL% NEQ 0 (
    echo Error: Build failed
    pause
    exit /b 1
)

echo.
echo Step 4: Running tests...

cd ..
if exist "test_output" rmdir /s /q "test_output"
mkdir "test_output"

REM Test basic functionality
echo Testing basic registration...
build\Release\spare.exe ..\data\test1\source.obj ..\data\test1\target.obj test_output\test_basic >test_output\test_basic.log 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Basic test failed - check test_output\test_basic.log
) else (
    echo Basic test passed
)

REM Test robot path functionality
if exist "examples\robot_path_simple.txt" (
    echo Testing robot path functionality...
    build\Release\spare.exe ..\data\test1\source.obj examples\robot_path_simple.txt ..\data\test1\target.obj test_output\test_robot >test_output\test_robot.log 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo Warning: Robot path test failed - check test_output\test_robot.log
    ) else (
        echo Robot path test passed
        if exist "test_output\test_robot_newpath.txt" (
            echo   - New robot path generated successfully
        )
    )
)

echo.
echo ========================================
echo Installation completed successfully!
echo ========================================
echo.
echo SPARE executable: %~dp0build\Release\spare.exe
echo Test outputs: %~dp0test_output\
echo.
echo Quick test command:
echo   cd "%~dp0build\Release"
echo   spare.exe --help
echo.
echo For more information, see:
echo   - README.md (detailed documentation)
echo   - QUICK_START.md (quick start guide)
echo   - examples\ (sample robot path files)
echo.
pause