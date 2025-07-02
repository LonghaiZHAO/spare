# SPARE Windows Build Script (PowerShell)
# This script builds SPARE for Windows using vcpkg and CMake

Write-Host "========================================" -ForegroundColor Green
Write-Host "SPARE Windows Build Script" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check if vcpkg is available
$vcpkgPath = Get-Command vcpkg -ErrorAction SilentlyContinue
if (-not $vcpkgPath) {
    Write-Host "Warning: vcpkg not found in PATH" -ForegroundColor Yellow
    Write-Host "Please install vcpkg and add it to your PATH, or specify VCPKG_ROOT" -ForegroundColor Yellow
    Write-Host ""
}

# Set default vcpkg root if not specified
if (-not $env:VCPKG_ROOT) {
    $env:VCPKG_ROOT = "C:\vcpkg"
}

Write-Host "Using vcpkg root: $env:VCPKG_ROOT" -ForegroundColor Cyan
Write-Host ""

# Check if vcpkg exists
$vcpkgExe = Join-Path $env:VCPKG_ROOT "vcpkg.exe"
if (-not (Test-Path $vcpkgExe)) {
    Write-Host "Error: vcpkg not found at $env:VCPKG_ROOT" -ForegroundColor Red
    Write-Host "Please install vcpkg or set VCPKG_ROOT environment variable" -ForegroundColor Red
    Write-Host ""
    Write-Host "To install vcpkg:" -ForegroundColor Yellow
    Write-Host "  git clone https://github.com/Microsoft/vcpkg.git" -ForegroundColor Yellow
    Write-Host "  cd vcpkg" -ForegroundColor Yellow
    Write-Host "  .\bootstrap-vcpkg.bat" -ForegroundColor Yellow
    Write-Host "  .\vcpkg integrate install" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Step 1: Installing dependencies with vcpkg..." -ForegroundColor Cyan
Write-Host ""

# Install dependencies
Write-Host "Installing Eigen3..." -ForegroundColor Yellow
& $vcpkgExe install eigen3:x64-windows
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install Eigen3" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Installing OpenMesh..." -ForegroundColor Yellow
& $vcpkgExe install openmesh:x64-windows
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install OpenMesh" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 2: Creating build directory..." -ForegroundColor Cyan
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Name "build" | Out-Null
}
Set-Location "build"

Write-Host ""
Write-Host "Step 3: Configuring CMake..." -ForegroundColor Cyan
$toolchainFile = Join-Path $env:VCPKG_ROOT "scripts\buildsystems\vcpkg.cmake"
cmake .. -DCMAKE_TOOLCHAIN_FILE="$toolchainFile" -DCMAKE_BUILD_TYPE=Release -A x64
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: CMake configuration failed" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 4: Building project..." -ForegroundColor Cyan
cmake --build . --config Release
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Build failed" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Executable location: build\Release\spare.exe" -ForegroundColor Cyan
Write-Host ""
Write-Host "To test the build:" -ForegroundColor Yellow
Write-Host "  cd build\Release" -ForegroundColor Yellow
Write-Host "  .\spare.exe --help" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"