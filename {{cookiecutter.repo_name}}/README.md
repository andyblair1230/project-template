# {{ cookiecutter.project_name }}

{{ cookiecutter.description }}

## Status
Version: `{{ cookiecutter.initial_version }}`

## Quick start

Windows (cmd or PowerShell):
    tasks.bat setup
    tasks.bat test

macOS/Linux:
    ./tasks.sh setup
    ./tasks.sh test

Or (macOS/Linux) with Make:
    make setup
    make test

{% if cookiecutter.use_python == "y" %}
## Python

### Dev install
    pip install -e ".[dev]" || pip install -r requirements.txt

### Lint, format, test
    ruff check .
    black --check .
    pytest -q
{% endif %}

{% if cookiecutter.use_node == "y" %}
## Node / TypeScript

### Install
    npm ci || npm install

### Lint, test
    npm run lint
    npm test
{% endif %}

{% if cookiecutter.use_go == "y" %}
## Go

### Setup
    go mod tidy

### Test
    go test ./...
{% endif %}

{% if cookiecutter.use_rust == "y" %}
## Rust

### Test
    cargo test
{% endif %}

## Common tasks

Windows:
    tasks.bat setup
    tasks.bat fmt
    tasks.bat lint
    tasks.bat test

macOS/Linux:
    ./tasks.sh setup
    ./tasks.sh fmt
    ./tasks.sh lint
    ./tasks.sh test

## CI
GitHub Actions run on every push and PR. See:
- `.github/workflows/ci-linux.yml`
- `.github/workflows/ci-windows.yml`

## Project structure
.
├─ docs/               # optional
├─ .github/workflows/  # CI
├─ tasks.sh / tasks.bat
├─ Makefile
{% if cookiecutter.use_python == "y" -%}
├─ pyproject.toml
├─ src/{{ cookiecutter.project_slug }}/
├─ tests/
{% endif -%}
{% if cookiecutter.use_node == "y" -%}
├─ package.json
├─ src/
├─ tests/
{% endif -%}
{% if cookiecutter.use_go == "y" -%}
├─ go.mod
├─ cmd/{{ cookiecutter.project_slug }}/
├─ internal/
{% endif -%}
{% if cookiecutter.use_rust == "y" -%}
├─ Cargo.toml
├─ src/
├─ tests/
{% endif -%}

## Releasing
- Update version file (e.g., `VERSION` or language-specific file).
- Tag a release:
    git tag -a v{{ cookiecutter.initial_version }} -m "release v{{ cookiecutter.initial_version }}"
    git push --tags

## License
This project is licensed under the {{ cookiecutter.license }} license.
