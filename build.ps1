# MS Windows PowerShell Build Script for Pi Pico
# rev 1 - june 2026 - shabaz
#
# Pre-requisites:
#   You'll need to install CMake https://cmake.org/download
#   and also Ninja https://github.com/ninja-build/ninja/releases
#   and also both a native Windows compiler (for example MSYS2 https://www.msys2.org/ )
#   and also the ARM GNU Toolchain https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
#   (for example, the file may be called arm-gnu-toolchain-15.2.rel1-mingw-w64-i686-arm-none-eabi.zip
#   if you're using 64-bit Windows)
# Configuration:
#   See all the comments in the script below, because you will need to edit items here to suit
#   your set-up.
# Using the script from a PowerShell command prompt:
#   Release Build: Type:
#     .\build.ps1
#   Debug Build: Type:
#     .\build.ps1 Debug
# Generated Output:
#   Output files will be generated in either build-Debug or build-Release folders


param(
    [ValidateSet("Debug", "Release", "RelWithDebInfo")]
    [string]$Config = "Release"
)

$ErrorActionPreference = "Stop"

# uncomment these and adjust the values, if you don't have
# PICO_SDK_PATH and PICO_TOOLCHAIN_PATH already set up as
# environment variables
# $env:PICO_SDK_PATH = "C:\DEV\projects\pico\pico-sdk"
# $env:PICO_TOOLCHAIN_PATH = "C:\DEV\arm_gnu_toolchains\15.2.rel1"

# comment these out if you already have CC and CXX set up
# as environment variables for a native compiler for your PC
# in this example, the native compiler is from an installation
# of MSYS2, but you could use Visual Studio compiler for instance.
$env:CC  = "C:/DEV/vhd_mounts/msys2/msys64/mingw64/bin/gcc.exe"
$env:CXX = "C:/DEV/vhd_mounts/msys2/msys64/mingw64/bin/g++.exe"

# modify this if you are missing the paths for the various tools
# or alternatively, add suitable paths to your PATH environment
# variable
$env:Path =
    "C:\DEV\vhd_mounts\msys2\msys64\mingw64\bin;" +
    "C:\DEV\arm_gnu_toolchains\15.2.rel1\bin;" +
    "C:\DEV\tools\bin;" +
    "C:\DEV\tools\cmake\bin;" +
    $env:Path

$buildDir = "build-$Config"

Write-Host ""
Write-Host "========================================"
Write-Host " Building $Config configuration"
Write-Host "========================================"
Write-Host ""
Write-Host "Build directory: $buildDir"
Write-Host ""

Write-Host "ARM Compiler:"
arm-none-eabi-gcc --version | Select-Object -First 1

Write-Host "WIN Compiler for picotool:"
& $env:CC --version | Select-Object -First 1

Write-Host ""

cmake -S . -B $buildDir -G Ninja "-DCMAKE_BUILD_TYPE:STRING=$Config"
cmake --build $buildDir
