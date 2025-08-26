# hooks/post_gen_project.py
import os
import shutil
import sys
import subprocess
from pathlib import Path
import stat

# Cookiecutter runs this from the GENERATED project root
ROOT = Path.cwd()

# Flags (must exist in cookiecutter.json)
USE_PY = "{{ cookiecutter.use_python }}".lower() == "y"
USE_NODE = "{{ cookiecutter.use_node }}".lower() == "y"
USE_GO = "{{ cookiecutter.use_go }}".lower() == "y"
USE_RS = "{{ cookiecutter.use_rust }}".lower() == "y"
USE_MKDOCS = "{{ cookiecutter.use_mkdocs }}".lower() == "y"
USE_DEVCON = "{{ cookiecutter.use_devcontainer }}".lower() == "y"
USE_CI = "{{ cookiecutter.use_ci }}".lower() == "y"
INIT_GIT = "{{ cookiecutter.init_git }}".lower() == "y"
LICENSE_SEL = "{{ cookiecutter.license }}"


def rm(relpath: str) -> None:
    p = ROOT / relpath
    if not p.exists():
        return
    if p.is_dir():
        shutil.rmtree(p, ignore_errors=True)
    else:
        try:
            p.unlink()
        except PermissionError:
            os.chmod(p, stat.S_IWRITE)
            p.unlink()


def make_executable(relpath: str) -> None:
    p = ROOT / relpath
    if p.exists():
        try:
            mode = p.stat().st_mode
            p.chmod(mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
        except Exception:
            pass  # Non-fatal on Windows


# 1) License handling (optional future expansion)
# if LICENSE_SEL == "Proprietary": pass

# 2) Prune stacks by flags
if not USE_PY:
    rm("pyproject.toml")
    rm(".python-version")
    # Add more Python-only files here when present (mypy.ini, ruff.toml, etc.)

if not USE_NODE:
    rm("package.json")
    rm("package-lock.json")
    rm("pnpm-lock.yaml")
    rm("yarn.lock")
    # rm("tsconfig.json"); rm("eslint.config.js"); rm(".prettierrc")

if not USE_GO:
    rm("go.mod")
    rm("go.sum")
    # rm("cmd"); rm("internal")

if not USE_RS:
    rm("Cargo.toml")
    rm("Cargo.lock")
    # If your template creates Rust sources:
    rm("src/main.rs")
    rm("src/lib.rs")
    rm("tests/sanity.rs")

# 3) Docs
if not USE_MKDOCS:
    rm("mkdocs.yml")
    rm("docs")

# 4) Devcontainer
if not USE_DEVCON:
    rm(".devcontainer")

# 5) CI
if not USE_CI:
    rm(".github/workflows/ci-linux.yml")
    rm(".github/workflows/ci-windows.yml")

# 6) Ensure scripts are executable on POSIX
make_executable("tasks.sh")

# 7) Optional: initialize git repository
if INIT_GIT:
    try:
        subprocess.run(["git", "init"], cwd=ROOT, check=True)
        subprocess.run(["git", "checkout", "-b", "main"], cwd=ROOT, check=False)
        subprocess.run(["git", "add", "-A"], cwd=ROOT, check=True)
        subprocess.run(["git", "commit", "-m", "Initial scaffold"], cwd=ROOT, check=True)
    except Exception as e:
        print(f"[warn] git init failed: {e}", file=sys.stderr)

# 8) Friendly final message
print("Project generated. Next steps:")
print("  - Review README for stack-specific commands")
print("  - Run: ./tasks.sh setup  (or tasks.bat setup on Windows)")
