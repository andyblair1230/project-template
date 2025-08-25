# Project Name

## 🚀 Quickstart

``powershell
# create a new project from this template
C:\dev\project-template\NewProject.bat

# activate virtual environment
.venv\Scripts\activate

# run tasks
tasks.bat lint
tasks.bat test
tasks.bat run
tasks.bat version

# docs
python -m mkdocs serve
``

---

## Using this template

1. Click **Use this template** on GitHub to create a new repo.
2. Clone your new repo locally.
3. (Optional) Create a Python 3.12 virtual environment:
   ``powershell
   py -3.12 -m venv .venv
   .\.venv\Scripts\activate
   ``
4. Install tooling (for automation scripts):
   ``powershell
   pip install pytest ruff
   ``
5. Run common tasks:
   ``powershell
   tasks.bat lint
   tasks.bat test
   tasks.bat run
   tasks.bat version
   ``
6. Docs (optional, MkDocs):
   ``powershell
   pip install mkdocs mkdocs-material
   python -m mkdocs serve
   ``

---

## Description
A short explanation of what this project does.

## Setup
Steps to install or prepare the project.

## Usage
Examples of how to run or use the project.

## Contributing
Notes for contributing or extending the project.

## License
Add your license here.

---

## 🆕 New Project Checklist

When you generate a new project from this template:

1. Run the generator
   - Double-click `NewProject.bat` (or run `C:\dev\project-template\NewProject.bat`).
   - Fill in the prompts (name, description, GitHub repo, etc.).

2. Activate the virtual environment
   ``powershell
   .venv\Scripts\activate
   ``

3. Run project tasks
   - `tasks.bat lint` → style checks  
   - `tasks.bat test` → run tests  
   - `tasks.bat clean` → clear caches and build outputs  

4. Docs
   - `python -m mkdocs serve` → preview docs locally at http://127.0.0.1:8000  
   - `python -m mkdocs build` → generate static site into `site/`  

5. GitHub
   - First run only: `gh auth login` (HTTPS, login with browser)  
   - Template already creates and pushes the repo (private by default).  
   - To link to a different repo, update your remote:  
     ``powershell
     git remote set-url origin https://github.com/<user>/<new_repo>.git
     git push -u origin main
     ``

6. Daily workflow
   - Edit code in `src/`  
   - Add tests in `tests/`  
   - Update docs in `docs/`  
   - Use `tasks.bat` to keep everything consistent  
