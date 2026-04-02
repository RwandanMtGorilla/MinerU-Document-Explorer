@echo off
:: Quick test script for MinerU Document Explorer on Windows

echo Testing MinerU Document Explorer installation...
echo.

:: Check if doc-search is available
where doc-search >nul 2>&1
if %errorlevel% neq 0 (
    echo [31mX[0m doc-search command not found
    echo    Please run setup.bat first
    exit /b 1
)

echo [92mV[0m doc-search CLI found

:: Check Python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do echo [92mV[0m Python version: %%i
) else (
    echo [31mX[0m Python not found
    exit /b 1
)

:: Check config
if exist "..\config-state.json" (
    echo [92mV[0m config-state.json found
) else (
    echo [33m![0m config-state.json not found - run setup.bat first
)

echo.
echo Installation looks good!
echo.
echo Next steps:
echo 1. Prepare a PDF file
echo 2. Run: doc-search init --doc_path "your_file.pdf"
echo.
