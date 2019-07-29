@echo off
SETLOCAL

: Save the path this script was called from.
set CALLPATH=%cd%

: Code repositories
set M_GIT=git@github.com:MicronOxford/microscope.git
set C_GIT=git@github.com:MicronOxford/cockpit.git

: Destination folder name
set DEST_FOLDER=MicronOxford 
 
: =================================
: Query the registry to find python
: =================================
set REG_PREFIXES=hklm hkcu
set PYTHON_VERSION=0
set PYTHON_KEY=''
for %%p in (%REG_PREFIXES%) do (call :regquery %%p)
if %PYTHON_VERSION% equ 0 (
    echo No python installation found. Exiting.
    exit /B )
echo %PYTHON_KEY%
for /f "tokens=3" %%p in ('reg query %PYTHON_KEY%\InstallPath') do (
    set PYTHON_PATH=%%p)
echo Ignore one or more errors above about finding registry keys/values.
echo.  
echo Python path is %PYTHON_PATH%
set PYTHON_EXE=%PYTHON_PATH%\python.exe

: =======================================
: Add ftgl.dll to the python DLLs folder.
: =======================================
echo Putting ftgl.dll on python path.
copy %~dp0ftgl.dll %PYTHON_PATH%\ftgl.dll


: ========================================
: Fetch and install microscope and cockpit
: ========================================
cd %ProgramFiles%
if not exist %DEST_FOLDER% (mkdir %DEST_FOLDER%)
cd %DEST_FOLDER%

: Clone source repositories
if exist "microscope" (echo No need to fetch microscope.) else (git clone %M_GIT%)
if exist "cockpit" (echo No need to fetch cockpit.) else (git clone %C_GIT%)

echo. & echo.Installing microscope.
cd microscope
%PYTHON_EXE% setup.py develop

echo. & echo.Installing cockpit
cd ../cockpit
%PYTHON_EXE% setup.py develop


: ===============================
: Create scripts and config files
: ===============================
set CONFIGDEST=%ProgramData%\cockpit\
set CONFIGSRC=testconfig\
set DEVICES=devices.py
set DEPOT=depot.conf

: Return to calling path to create scripts.
cd %CALLPATH%

: Create dummy config files if needed.
if not exist %CONFIGDEST% (
  mkdir %CONFIGDEST% & echo Created config folder.) else (
  echo Config folder already exists.)

if not exist %CONFIGDEST%%DEVICES% (
  copy %CONFIGSRC%%DEVICES% %CONFIGDEST%%DEVICES% & echo Created device file.) else (
  echo Devices file already exists.)

if not exist %CONFIGDEST%%DEPOT% (
  copy %CONFIGSRC%%DEPOT% %CONFIGDEST%%DEPOT% & echo Created depot file.) else (
  echo Depot file already exists.)

: Create scripts to start microscope and cockpit
echo Creating scripts.
if not exist "scripts" (mkdir scripts)

: _cockpit.bat
echo %PYTHON_PATH%\Scripts\cockpit.exe > scripts\_cockpit.bat
echo exit >> scripts\_cockpit.bat

: _microscope.bat
echo python -m microscope.deviceserver %CONFIGDEST%%DEVICES% > scripts\_microscope.bat

: Link to config folder
if not exist scripts/config_files (mklink /D "scripts/config_files" %CONFIGDEST%)

ENDLOCAL

echo. & echo. "microscope and cockpit installed"
exit /b

: Determine available python versions user HKLM or HKCU
:regquery
 set REG_KEY=%1\software\python\pythoncore
 (for /f "tokens=5 delims=\" %%v in ('reg query "%REG_KEY%"') do (
   if %%v gtr %PYTHON_VERSION% (
      set PYTHON_VERSION=%%v
      set PYTHON_KEY=%REG_KEY%\%%v
 )))
 GOTO :eof