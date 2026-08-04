@echo off
setlocal enableextensions

:: Paths
set VST_SRC=obsidian-vst.vst3
set ARA_SRC=obsidian-ara.vst3

set VST_TARGET=synthv-studio-plugin-x64.vst3
set ARA_TARGET=synthv-studio-araplugin-x64.vst3

set TMP_DIR=%TEMP%\ObsidianInstallTemp

set VST3_DIR=%ProgramFiles%\Common Files\VST3

:: Create temp folder intermediary storage
mkdir "%TMP_DIR%" >nul 2>&1

:: Change to the script's directory
cd /d "%~dp0"

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] This script needs to run as Administrator.
    echo [INFO] Prompting for elevation with PowerShell, press any key to bring the prompt...

    where powershell >nul 2>&1 || (
        echo [ERROR] PowerShell not found. Cannot elevate.
        goto end
    )
    powershell -Command "Start-Process '%~f0' -WorkingDirectory '%CD%' -Verb RunAs"
    exit /b
)

:: Check source files exist
if not exist "%VST_SRC%" (
    echo [ERROR] "%VST_SRC%" not found in current folder.
    goto end
)
if not exist "%ARA_SRC%" (
    echo [ERROR] "%ARA_SRC%" not found in current folder.
    goto end
)

if not exist "%VST3_DIR%\%VST_TARGET%\" (
    if not exist "%VST3_DIR%\%VST_TARGET%" (
        echo [ERROR] "%VST3_DIR%\%VST_TARGET%" not found in VST3 folder. Please make sure you installed Synthesizer V Studio properly.
        goto end
    )

    :: Create VST target folder structure
    echo Installing %VST_TARGET%...
    move /Y "%VST3_DIR%\%VST_TARGET%" "%TMP_DIR%\%VST_TARGET%" >nul
    mkdir "%VST3_DIR%\%VST_TARGET%\Contents\x86_64-win" >nul 2>&1
    mkdir "%VST3_DIR%\%VST_TARGET%\Contents\Resources" >nul 2>&1

    :: Move the existing file to Resources folder
    if exist "%VST3_DIR%\%VST_TARGET%" (
        ren "%TMP_DIR%\%VST_TARGET%" "%VST_TARGET:.vst3=.dat%"
        move /Y "%TMP_DIR%\%VST_TARGET:.vst3=.dat%" "%VST3_DIR%\%VST_TARGET%\Contents\Resources\" >nul
    )

    :: Copy new plugin into x86_64-win
    copy /Y "%VST_SRC%" "%VST3_DIR%\%VST_TARGET%\Contents\x86_64-win\%VST_TARGET%" >nul
) else (
    echo [INFO] Obsidian VST3 is already installed!
)

if not exist "%VST3_DIR%\%ARA_TARGET%\" (
    if not exist "%VST3_DIR%\%ARA_TARGET%" (
        echo [ERROR] "%VST3_DIR%\%ARA_TARGET%" not found in VST3 folder. Please make sure you installed Synthesizer V Studio properly.
        goto end
    )

    :: Create ARA target folder structure
    echo Installing %ARA_TARGET%...
    move /Y "%VST3_DIR%\%ARA_TARGET%" "%TMP_DIR%\%ARA_TARGET%" >nul
    mkdir "%VST3_DIR%\%ARA_TARGET%\Contents\x86_64-win" >nul 2>&1
    mkdir "%VST3_DIR%\%ARA_TARGET%\Contents\Resources" >nul 2>&1

    :: Move the existing ARA file to Resources folder
    if exist "%VST3_DIR%\%ARA_TARGET%" (
        ren "%TMP_DIR%\%ARA_TARGET%" "%ARA_TARGET:.vst3=.dat%"
        move /Y "%TMP_DIR%\%ARA_TARGET:.vst3=.dat%" "%VST3_DIR%\%ARA_TARGET%\Contents\Resources\" >nul
    )

    :: Copy new plugin into x86_64-win
    copy /Y "%ARA_SRC%" "%VST3_DIR%\%ARA_TARGET%\Contents\x86_64-win\%ARA_TARGET%" >nul
) else (
    echo [INFO] Obsidian ARA is already installed!
)

echo Done.
goto end

:end
:: Delete temp folder
rmdir "%TMP_DIR%" >nul 2>&1

pause
