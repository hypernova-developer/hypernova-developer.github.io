@echo off
setlocal enabledelayedexpansion
title Jenny ^& CompileX ^& SyntaX - Global Genesis Setup
color 0b

echo.
echo  ######################################################
echo  #                                                    #
echo  #         GLOBAL GENESIS: THE POWER TRIAD            #
echo  #      (Jenny ^| CompileX ^| SyntaX Library)         #
echo  #          --------------------------------          #
echo  #         Deployment of the Power Ecosystem          #
echo  #                                                    #
echo  ######################################################
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [X] ERROR: System changes require Administrator privileges.
    echo [!] Please right-click and "Run as Administrator".
    pause & exit
)

echo [*] Checking for Core Tools (Git ^& Python)...
where git >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Git not found. Installing via Winget...
    winget install --id Git.Git -e --source winget --silent
)

where python >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Python not found. Installing via Winget...
    winget install --id Python.Python.3.12 -e --source winget --silent
)

echo [*] Initializing Directory Structures...
if not exist "C:\Tools\Jenny" mkdir "C:\Tools\Jenny"
if not exist "C:\Tools\CompileX" mkdir "C:\Tools\CompileX"
if not exist "C:\Tools\SyntaX" mkdir "C:\Tools\SyntaX"
if not exist "C:\Tools\MinGW" mkdir "C:\Tools\MinGW"

echo [*] Deploying Jenny Engine...
if not exist "C:\Tools\Jenny\.git" (
    git clone https://github.com/hypernova-developer/Jenny C:\Tools\Jenny
) else (
    cd /d "C:\Tools\Jenny" && git pull
)

echo [*] Deploying CompileX Engine...
if not exist "C:\Tools\CompileX\.git" (
    git clone https://github.com/hypernova-developer/CompileX C:\Tools\CompileX
) else (
    cd /d "C:\Tools\CompileX" && git pull
)

echo [*] Deploying SyntaX Library Collection...
if not exist "C:\Tools\SyntaX\.git" (
    git clone https://github.com/hypernova-developer/SyntaX C:\Tools\SyntaX
) else (
    cd /d "C:\Tools\SyntaX" && git pull
)

echo [*] Downloading MinGW-w64 (Winlibs GCC 14.2.0)...
set "MINGW_URL=https://github.com/brechtsanders/winlibs_mingw64/releases/download/14.2.0posix-18.1.8-12.0.0-ucrt-r1/winlibs-x86_64-posix-seh-gcc-14.2.0-llvm-18.1.8-mingw-w64ucrt-12.0.0-r1.zip"

if not exist "C:\Tools\MinGW\bin" (
    echo [!] Downloading compiler suite (150MB+)...
    curl -L %MINGW_URL% -o %temp%\mingw.zip
    echo [*] Extracting files...
    powershell -Command "Expand-Archive -Path '%temp%\mingw.zip' -DestinationPath 'C:\Tools\MinGW' -Force"
    
    if exist "C:\Tools\MinGW\mingw64" (
        move "C:\Tools\MinGW\mingw64\*" "C:\Tools\MinGW\"
        rmdir "C:\Tools\MinGW\mingw64"
    )
    del %temp%\mingw.zip
)

echo [*] Installing Python requirements for Jenny...
if exist "C:\Tools\Jenny\requirements.txt" (
    python -m pip install --upgrade pip
    pip install -r C:\Tools\Jenny\requirements.txt
)

echo [*] Optimizing System Environment Variables...
set "NEW_PATHS=C:\Tools\Jenny;C:\Tools\CompileX;C:\Tools\MinGW\bin"
setx /M PATH "%PATH%;%NEW_PATHS%"
setx /M C_INCLUDE_PATH "C:\Tools\SyntaX"
setx /M CPLUS_INCLUDE_PATH "C:\Tools\SyntaX"
setx /M SYNTAX_HOME "C:\Tools\SyntaX"

echo.
echo  ======================================================
echo    [SUCCESS] GENESIS DEPLOYMENT COMPLETE!
echo  ======================================================
echo    - Jenny: Ready (jenny --help)
echo    - CompileX: Ready (compilex --help)
echo    - SyntaX: Auto-Include Active (.h ^& .hpp)
echo    - MinGW GCC 14.2.0: Ready (gcc --version)
echo  ======================================================
echo.
pause
