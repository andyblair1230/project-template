@echo off
setlocal enabledelayedexpansion

REM Usage: tasks.bat <command>
REM Commands: help | test | lint | run | clean

if "%1"=="" goto :help
if /I "%1"=="help" goto :help
if /I "%1"=="test" goto :test
if /I "%1"=="lint" goto :lint
if /I "%1"=="run"  goto :run
if /I "%1"=="clean" goto :clean
if /I "%1"=="version" goto :version
if /I "%1"=="bump:patch" goto :bump_patch
if /I "%1"=="bump:minor" goto :bump_minor
if /I "%1"=="bump:major" goto :bump_major

echo Unknown command: %1
goto :end

:help
echo Available commands:
echo   tasks.bat test   - run tests (pytest)
echo   tasks.bat lint   - check code style (ruff)
echo   tasks.bat run    - run the project (python -m src)
echo   tasks.bat clean  - remove build artifacts and caches
echo   tasks.bat version     - show current version (from VERSION)
echo   tasks.bat bump:patch  - bump patch (X.Y.Z -> X.Y.(Z+1))
echo   tasks.bat bump:minor  - bump minor (X.Y.Z -> X.(Y+1).0)
echo   tasks.bat bump:major  - bump major ((X+1).0.0)
goto :end

:test
where pytest >nul 2>nul
if errorlevel 1 (
  echo pytest not found. Install it with: pip install pytest
  goto :end
)
pytest -q
goto :end

:lint
where ruff >nul 2>nul
if errorlevel 1 (
  echo ruff not found. Install it with: pip install ruff
  goto :end
)
ruff check .
goto :end

:run
where python >nul 2>nul
if errorlevel 1 (
  echo Python not found on PATH.
  goto :end
)
python -m src
goto :end

:clean
REM /Q = quiet, /S = include subdirectories
del /Q /S *.pyc 2>nul
del /Q /S *.pyo 2>nul
del /Q /S *.log 2>nul
rmdir /Q /S build 2>nul
rmdir /Q /S dist 2>nul
rmdir /Q /S .pytest_cache 2>nul
rmdir /Q /S __pycache__ 2>nul
echo Clean complete.
goto :end

:version
for /f "usebackq delims=" %%v in ("VERSION") do set CURR=%%v
echo %CURR%
goto :end

:bump_patch
for /f "tokens=1-3 delims=." %%a in (VERSION) do (
  set MAJ=%%a
  set MIN=%%b
  set PAT=%%c
)
set /a PAT=%PAT%+1
>VERSION echo %MAJ%.%MIN%.%PAT%
echo Bumped to %MAJ%.%MIN%.%PAT%
goto :end

:bump_minor
for /f "tokens=1-3 delims=." %%a in (VERSION) do (
  set MAJ=%%a
  set MIN=%%b
)
set /a MIN=%MIN%+1
>VERSION echo %MAJ%.%MIN%.0
echo Bumped to %MAJ%.%MIN%.0
goto :end

:bump_major
for /f "tokens=1 delims=." %%a in (VERSION) do (
  set MAJ=%%a
)
set /a MAJ=%MAJ%+1
>VERSION echo %MAJ%.0.0
echo Bumped to %MAJ%.0.0
goto :end

:end
endlocal
