import os
import subprocess
import sys
from pathlib import Path

# Values injected by Cookiecutter at render time:
SETUP_VENV = "{{ cookiecutter.setup_venv }}".lower().startswith("y")
PY_VER     = "{{ cookiecutter.python_version }}"
INSTALL_DEV= "{{ cookiecutter.install_dev_tools }}".lower().startswith("y")
INSTALL_DOC= "{{ cookiecutter.install_mkdocs }}".lower().startswith("y")
INIT_GIT   = "{{ cookiecutter.init_git }}".lower().startswith("y")
DEFAULT_BR = "{{ cookiecutter.default_branch }}"
CREATE_GH  = "{{ cookiecutter.create_github_repo }}".lower().startswith("y")
GH_USER    = "{{ cookiecutter.github_user }}"
PRIVATE_REPO = "{{ cookiecutter.private_repo }}".lower().startswith("y")
REPO_NAME  = "{{ cookiecutter.repo_name }}"

cwd = Path.cwd()

def run(cmd, check=True):
    # Print and run a command; return CompletedProcess
    print(f"$ {' '.join(cmd)}")
    return subprocess.run(cmd, check=check)

def file_exists(*parts):
    return (cwd.joinpath(*parts)).exists()

def venv_python_path():
    if os.name == "nt":
        return str(cwd / ".venv" / "Scripts" / "python.exe")
    else:
        return str(cwd / ".venv" / "bin" / "python")

def ensure_venv():
    # Create venv with the Windows launcher if present, else fallback
    if os.name == "nt":
        run(["py", f"-{PY_VER}", "-m", "venv", ".venv"])
    else:
        # best effort for non-Windows clones of this template
        run(["python3", "-m", "venv", ".venv"])
    vp = venv_python_path()
    run([vp, "-m", "pip", "install", "--upgrade", "pip"])
    return vp

def install_tools(vp):
    pkgs = []
    if INSTALL_DEV:
        pkgs += ["pytest", "ruff"]
    if INSTALL_DOC:
        pkgs += ["mkdocs", "mkdocs-material"]
    if pkgs:
        run([vp, "-m", "pip", "install", *pkgs])

def init_git_repo():
    # git init with branch; older Git may not support -b
    try:
        run(["git", "init", "-b", DEFAULT_BR])
    except subprocess.CalledProcessError:
        run(["git", "init"])
        run(["git", "checkout", "-b", DEFAULT_BR])
    run(["git", "add", "-A"])
    # Make a first commit; if user.email/name not set, this may fail
    try:
        run(["git", "commit", "-m", "Initial commit from template"])
    except subprocess.CalledProcessError as e:
        print("WARN: git commit failed (likely no user.email configured). Skipping initial commit.")
        print(e)

def create_github_repo():
    # Requires GitHub CLI (`gh`) and that you're authenticated: `gh auth login`
    # Determine visibility flag
    vis = "--private" if PRIVATE_REPO else "--public"
    # Create repo from current directory and push
    run([
        "gh", "repo", "create", f"{GH_USER}/{REPO_NAME}",
        "--source", ".", "--remote", "origin", "--push",
        "--branch", DEFAULT_BR, vis
    ])

def main():
    vp = None
    if SETUP_VENV:
        try:
            vp = ensure_venv()
        except Exception as e:
            print("ERROR: Failed to create virtual environment:", e)
            # continue without venv

    if vp:
        try:
            install_tools(vp)
        except Exception as e:
            print("WARN: Tool installation failed:", e)

    if INIT_GIT:
        try:
            init_git_repo()
        except Exception as e:
            print("WARN: Git initialization failed:", e)

    if CREATE_GH:
        try:
            # Verify gh is available
            res = run(["gh", "--version"], check=False)
            if res.returncode != 0:
                print("WARN: GitHub CLI (gh) not found. Skipping repo creation.")
            else:
                create_github_repo()
        except Exception as e:
            print("WARN: GitHub repo creation failed:", e)

if __name__ == "__main__":
    main()
