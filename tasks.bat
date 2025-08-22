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

echo Unknown command: %1
goto :end

:help
echo Available commands:
echo   tasks.bat test   - run tests (pytest)
echo   tasks.bat lint   - check code style (ruff)
echo   tasks.bat run    - run the project (python -m src)
echo   tasks.bat clean  - remove build artifacts and caches
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

:end
endlocal
