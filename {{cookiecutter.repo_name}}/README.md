# {{ cookiecutter.project_name }}

{{ cookiecutter.description }}

## Using this project
- Create a Python 3.12 virtual environment (optional):
  py -3.12 -m venv .venv
  .\.venv\Scripts\activate
- Install tooling for automation:
  pip install pytest ruff
- Common tasks:
  tasks.bat lint
  tasks.bat test
  tasks.bat run
  tasks.bat version

## Docs
- Local preview:
  pip install mkdocs mkdocs-material
  python -m mkdocs serve
