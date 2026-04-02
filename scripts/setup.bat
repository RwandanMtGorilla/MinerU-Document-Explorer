@echo off
setlocal EnableDelayedExpansion

:: MinerU Document Explorer - Windows Setup Script
:: Installs the bundled doc-search package and verifies it works.

echo === MinerU Document Explorer Setup ===
echo.

:: -----------------------------------------------------------
:: 1. Get script directory and skill directory
:: -----------------------------------------------------------
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "SKILL_DIR=%SCRIPT_DIR%\.."
cd /d "%SKILL_DIR%"

:: -----------------------------------------------------------
:: 2. Check bundled source exists
:: -----------------------------------------------------------
if not exist "scripts\doc-search\pyproject.toml" (
    echo [31mX[0m Bundled doc-search source not found at: scripts\doc-search
    exit /b 1
)

:: -----------------------------------------------------------
:: 3. Find Python ^>= 3.10
:: -----------------------------------------------------------
set "PYTHON="

:: Try py launcher first (recommended on Windows)
py -0 >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=2 delims= " %%i in ('py -0 2^>^&1 ^| findstr /R "^  3\.1[0-9]"') do (
        set "PYTHON=py"
        set "PYTHON_VER=%%i"
        goto :found_python
    )
)

:: Try python command
python --version >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=2 delims= " %%i in ('python --version 2^>^&1') do set "PYTHON_VER=%%i"
    set "PYTHON=python"
    goto :check_version
)

:: Try python3 command
python3 --version >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=2 delims= " %%i in ('python3 --version 2^>^&1') do set "PYTHON_VER=%%i"
    set "PYTHON=python3"
    goto :check_version
)

echo [31mX[0m Python 3.10+ not found.
echo    Download from: https://www.python.org/downloads/
exit /b 1

:check_version
:: Check if version is ^>= 3.10
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VER%") do (
    set "MAJOR=%%a"
    set "MINOR=%%b"
)
if %MAJOR% lss 3 (
    echo [31mX[0m Python %PYTHON_VER% found, but 3.10+ required
    exit /b 1
)
if %MAJOR% equ 3 if %MINOR% lss 10 (
    echo [31mX[0m Python %PYTHON_VER% found, but 3.10+ required
    exit /b 1
)

:found_python
if not defined PYTHON_VER set "PYTHON_VER=unknown"
for /f "tokens=*" %%i in ('where %PYTHON% 2^>nul') do set "PYTHON_PATH=%%i"
if not defined PYTHON_PATH set "PYTHON_PATH=%PYTHON%"
echo [92mV[0m Found Python %PYTHON_VER%: %PYTHON_PATH%

:: -----------------------------------------------------------
:: 4. Install doc-search from bundled source (editable)
:: -----------------------------------------------------------
echo.
echo [33mInstalling doc-search from bundled source (with all dependencies)...[0m
%PYTHON% -m pip install -e "scripts\doc-search[all]" -q
if !errorlevel! neq 0 (
    echo [31mX[0m Installation failed
    echo    Try: %PYTHON% -m pip install -e scripts\doc-search[all]
    exit /b 1
)

:: -----------------------------------------------------------
:: 5. Verify CLI is available
:: -----------------------------------------------------------
where doc-search >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=*" %%i in ('where doc-search 2^>nul') do set "CLI_PATH=%%i"
    echo [92mV[0m doc-search CLI available: !CLI_PATH!
) else (
    echo [33m![0m doc-search not on PATH after install.
    echo    Try: %PYTHON% -m pip install -e scripts\doc-search[all]
    echo    Or add Python Scripts folder to your PATH
    exit /b 1
)

:: -----------------------------------------------------------
:: 6. Setup config (copy template if not exists; never overwrite)
:: -----------------------------------------------------------
set "CONFIG_FILE=scripts\doc-search\config.yaml"
if not exist "%CONFIG_FILE%" (
    copy "scripts\doc-search\config-example.yaml" "%CONFIG_FILE%" >nul
    echo [93m+[0m Created config.yaml - default server pre-configured, ready to use.
) else (
    echo [92mV[0m Config exists: %CONFIG_FILE%
)

:: -----------------------------------------------------------
:: 7. Write state file (using Python for JSON generation)
:: -----------------------------------------------------------
set "STATE_FILE=config-state.json"
for /f "tokens=*" %%i in ('%PYTHON% -c "import datetime; print(datetime.datetime.utcnow().strftime('%%Y-%%m-%%dT%%H:%%M:%%SZ'))"') do set "TIMESTAMP=%%i"

%PYTHON% -c "import json,os; json.dump({'setup_complete': True, 'doc_search_src': os.path.abspath('scripts/doc-search').replace('\\\\', '/'), 'config_path': os.path.abspath('scripts/doc-search/config.yaml').replace('\\\\', '/'), 'python': r'%PYTHON_PATH%', 'installed_at': r'%TIMESTAMP%'}, open('config-state.json', 'w'), indent=2)"

echo.
echo === Setup Complete ===
echo State:  %STATE_FILE%
echo Config: %CONFIG_FILE%
echo.
echo Ready to use: doc-search init --doc_path your_file.pdf
echo.
echo Optional: to enable PageIndex (smart TOC for documents without bookmarks),
echo   set pageindex_model, pageindex_api_key, pageindex_base_url in config.yaml.
echo.
