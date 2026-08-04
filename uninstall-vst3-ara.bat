@echo off
setlocal enableextensions

:: Plugin target names
set VST_TARGET=synthv-studio-plugin-x64.vst3
set ARA_TARGET=synthv-studio-araplugin-x64.vst3

set VST3_DIR=%ProgramFiles%\Common Files\VST3
set TMP_DIR=%TEMP%\ObsidianUninstallTemp

:: Prepare temp dir
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

:: Uninstall VST
if exist "%VST3_DIR%\%VST_TARGET%\" (
    echo Uninstalling %VST_TARGET%...

    :: Move plugin folder to temp (to make room for restored file)
    move /Y "%VST3_DIR%\%VST_TARGET%" "%TMP_DIR%\%VST_TARGET%" >nul

    if exist "%TMP_DIR%\%VST_TARGET%\Contents\Resources\%VST_TARGET:.vst3=.dat%" (
        echo Restoring original VST plugin...
        ren "%TMP_DIR%\%VST_TARGET%\Contents\Resources\%VST_TARGET:.vst3=.dat%" "%VST_TARGET%"
        move /Y "%TMP_DIR%\%VST_TARGET%\Contents\Resources\%VST_TARGET%" "%VST3_DIR%\%VST_TARGET%" >nul
    )
) else (
    echo [WARN] Obsidian VST3 is not installed.
)

:: Uninstall ARA
if exist "%VST3_DIR%\%ARA_TARGET%\" (
    echo Uninstalling %ARA_TARGET%...

    :: Move plugin folder to temp (to make room for restored file)
    move /Y "%VST3_DIR%\%ARA_TARGET%" "%TMP_DIR%\%ARA_TARGET%" >nul

    if exist "%TMP_DIR%\%ARA_TARGET%\Contents\Resources\%ARA_TARGET:.vst3=.dat%" (
        echo Restoring original ARA plugin...
        ren "%TMP_DIR%\%ARA_TARGET%\Contents\Resources\%ARA_TARGET:.vst3=.dat%" "%ARA_TARGET%"
        move /Y "%TMP_DIR%\%ARA_TARGET%\Contents\Resources\%ARA_TARGET%" "%VST3_DIR%\%ARA_TARGET%" >nul
    )
) else (
    echo [WARN] Obsidian ARA is not installed.
)

echo Done.

:end
:: Clean up temp dir
rmdir /S /Q "%TMP_DIR%" >nul 2>&1

pause
