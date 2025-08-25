@echo off
setlocal enabledelayedexpansion

REM Cross-stack task runner for Windows
REM usage: tasks.bat {help|setup|fmt|lint|test|run|clean|version|bump:patch|bump:minor|bump:major}

if "%~1"=="" set CMD=help& goto :dispatch
set CMD=%~1

:dispatch
if /I "%CMD%"=="help"       goto :help
if /I "%CMD%"=="setup"      goto :setup
if /I "%CMD%"=="fmt"        goto :fmt
if /I "%CMD%"=="lint"       goto :lint
if /I "%CMD%"=="test"       goto :test
if /I "%CMD%"=="run"        goto :run
if /I "%CMD%"=="clean"      goto :clean
if /I "%CMD%"=="version"    goto :version
if /I "%CMD%"=="bump:patch" goto :bump_patch
if /I "%CMD%"=="bump:minor" goto :bump_minor
if /I "%CMD%"=="bump:major" goto :bump_major
echo Unknown command: %CMD%
goto :end

:help
echo Available commands:
echo   tasks.bat setup   - install deps (Python/Node/Go/Rust)
echo   tasks.bat fmt     - auto-format where applicable
echo   tasks.bat lint    - static checks
echo   tasks.bat test    - run tests
echo   tasks.bat run     - run the project
echo   tasks.bat clean   - remove build artifacts and caches
echo   tasks.bat version - show current version (from VERSION)
echo   tasks.bat bump:patch ^| bump:minor ^| bump:major
goto :end

:setup
if exist pyproject.toml (
  where python >nul 2>nul && (
    python -m pip install -U pip
    rem try dev install, fallback to requirements.txt
    pip install -e ".[dev]" || pip install -r requirements.txt
  ) || echo [setup] Python not on PATH.
)
if exist package.json (
  where npm >nul 2>nul && ( npm ci || npm install ) || echo [setup] npm not on PATH.
)
if exist go.mod (
  where go >nul 2>nul && ( go mod tidy ) || echo [setup] Go not on PATH.
)
if exist Cargo.toml (
  where cargo >nul 2>nul && ( cargo fetch ) || echo [setup] Cargo not on PATH.
)
goto :end

:fmt
if exist pyproject.toml (
  where ruff >nul 2>nul && ruff check --fix . || echo [fmt] ruff not found.
  where black >nul 2>nul && black . || echo [fmt] black not found.
)
if exist package.json ( where npm >nul 2>nul && npm run fmt || echo [fmt] npm not found. )
if exist go.mod ( where go >nul 2>nul && go fmt ./... || echo [fmt] go not found. )
if exist Cargo.toml ( where cargo >nul 2>nul && cargo fmt || echo [fmt] cargo not found. )
goto :end

:lint
if exist pyproject.toml (
  where ruff >nul 2>nul && ruff check . || echo [lint] ruff not found.
  where mypy >nul 2>nul && mypy . || echo [lint] mypy not found.
)
if exist package.json ( where npm >nul 2>nul && npm run lint || echo [lint] npm not found. )
if exist go.mod ( where golangci-lint >nul 2>nul && golangci-lint run || echo [lint] golangci-lint not found. )
if exist Cargo.toml ( where cargo >nul 2>nul && cargo clippy -D warnings || echo [lint] cargo/clippy not found. )
goto :end

:test
if exist pyproject.toml ( where pytest >nul 2>nul && pytest -q || echo [test] pytest not found. )
if exist package.json ( where npm >nul 2>nul && npm test --silent || echo [test] npm not found. )
if exist go.mod ( where go >nul 2>nul && go test ./... || echo [test] go not found. )
if exist Cargo.toml ( where cargo >nul 2>nul && cargo test || echo [test] cargo not found. )
goto :end

:run
if exist pyproject.toml ( where python >nul 2>nul && python -m src || echo [run] python not found. )
if exist package.json ( where npm >nul 2>nul && npm start || echo [run] npm not found. )
if exist go.mod ( where go >nul 2>nul && go run ./cmd/... || echo [run] go not found. )
if exist Cargo.toml ( where cargo >nul 2>nul && cargo run || echo [run] cargo not found. )
goto :end

:clean
del /Q /S *.pyc 2>nul
del /Q /S *.pyo 2>nul
del /Q /S *.log 2>nul
rmdir /Q /S build 2>nul
rmdir /Q /S dist 2>nul
rmdir /Q /S .pytest_cache 2>nul
rmdir /Q /S .ruff_cache 2>nul
rmdir /Q /S __pycache__ 2>nul
if exist package.json rmdir /Q /S node_modules 2>nul
echo Clean complete.
goto :end

:version
if exist VERSION (
  for /f "usebackq delims=" %%v in ("VERSION") do set CURR=%%v
  echo %CURR%
) else (
  echo VERSION file not found.
)
goto :end

:bump_patch
for /f "tokens=1-3 delims=." %%a in (VERSION) do ( set MAJ=%%a & set MIN=%%b & set PAT=%%c )
set /a PAT=%PAT%+1
>VERSION echo %MAJ%.%MIN%.%PAT%
echo Bumped to %MAJ%.%MIN%.%PAT%
goto :end

:bump_minor
for /f "tokens=1-2 delims=." %%a in (VERSION) do ( set MAJ=%%a & set MIN=%%b )
set /a MIN=%MIN%+1
>VERSION echo %MAJ%.%MIN%.0
echo Bumped to %MAJ%.%MIN%.0
goto :end

:bump_major
for /f "tokens=1 delims=." %%a in (VERSION) do ( set MAJ=%%a )
set /a MAJ=%MAJ%+1
>VERSION echo %MAJ%.0.0
echo Bumped to %MAJ%.0.0
goto :end

:end
endlocal
