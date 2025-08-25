# Project Template

Language-agnostic Cookiecutter template with optional stacks (Python, Node/TS, Go, Rust), cross-platform tasks (Windows batch + POSIX shell), and ready-to-run CI for Linux and Windows.

## What this repo is
This is the TEMPLATE. You use it to generate new projects. The generated project will have its own README tailored to the stacks you choose.

## Use this template

Option A — GitHub button:
1) Click “Use this template” → “Create a new repository”
2) Clone your new repo and follow its README (auto-generated)

Option B — Cookiecutter (recommended for options):
1) Install Cookiecutter in any Python 3.12+ environment:
    pip install cookiecutter
2) Generate a project:
    cookiecutter https://github.com/andyblair1230/project-template
3) Answer prompts (project name, stacks, CI, docs, etc.)
4) cd into the new folder and follow its README

## Template options (prompts)
- use_python (y/n)
- use_node (y/n)
- use_go (y/n)
- use_rust (y/n)
- use_mkdocs (y/n)
- use_ci (y/n)
- use_devcontainer (y/n)
- init_git (y/n)
- license (MIT / Apache-2.0 / Unlicense / Proprietary)

## What gets generated
- Cross-platform task runners: `tasks.bat` (Windows) and `tasks.sh` (macOS/Linux)
- Optional stacks (only what you select):
  - Python: `pyproject.toml`, `src/`, `tests/`
  - Node/TS: `package.json`, `src/`, `tests/`
  - Go: `go.mod`, `cmd/…`, `internal/`
  - Rust: `Cargo.toml`, `src/`, `tests/`
- CI: `.github/workflows/ci-linux.yml` and `ci-windows.yml` (if enabled)
- Docs: `mkdocs.yml` and `docs/` (if enabled)

## Developing the TEMPLATE (this repo)
Windows (cmd or PowerShell):
    tasks.bat lint
    tasks.bat test

macOS/Linux:
    ./tasks.sh lint
    ./tasks.sh test

CI runs on all PRs (Linux + Windows). Keep main green.

## License
This repository is the template; the generated project’s license is chosen at generation time.
