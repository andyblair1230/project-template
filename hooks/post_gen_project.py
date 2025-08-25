import os
import subprocess
from pathlib import Path

# Cookiecutter vars
SETUP_VENV   = "{{ cookiecutter.setup_venv }}".lower().startswith("y")
PY_VER       = "{{ cookiecutter.python_version }}"
INSTALL_DEV  = "{{ cookiecutter.install_dev_tools }}".lower().startswith("y")
INSTALL_DOC  = "{{ cookiecutter.install_mkdocs }}".lower().startswith("y")
INIT_GIT     = "{{ cookiecutter.init_git }}".lower().startswith("y")
DEFAULT_BR   = "{{ cookiecutter.default_branch }}"
CREATE_GH    = "{{ cookiecutter.create_github_repo }}".lower().startswith("y")
GH_USER      = "{{ cookiecutter.github_user }}"
PRIVATE_REPO = "{{ cookiecutter.private_repo }}".lower().startswith("y")
REPO_NAME    = "{{ cookiecutter.repo_name }}"

CWD = Path.cwd()


def run(cmd, check=True):
    """Print and run a command."""
    print(f"$ {' '.join(cmd)}")
    return subprocess.run(cmd, check=check)


def venv_python_path() -> str:
    if os.name == "nt":
        return str(CWD / ".venv" / "Scripts" / "python.exe")
    return str(CWD / ".venv" / "bin" / "python")


def ensure_venv() -> str | None:
    """Create a venv and upgrade pip. Returns python path or None on failure."""
    try:
        if os.name == "nt":
            run(["py", f"-{PY_VER}", "-m", "venv", ".venv"])
        else:
            run(["python3", "-m", "venv", ".venv"])
        vp = venv_python_path()
        run([vp, "-m", "pip", "install", "--upgrade", "pip"])
        return vp
    except Exception as e:
        print("ERROR: Failed to create virtual environment:", e)
        return None


def install_tools(vp: str) -> None:
    pkgs = []
    if INSTALL_DEV:
        pkgs += ["pytest", "ruff"]
    if INSTALL_DOC:
        pkgs += ["mkdocs", "mkdocs-material"]
    if pkgs:
        try:
            run([vp, "-m", "pip", "install", *pkgs])
        except Exception as e:
            print("WARN: Tool installation failed:", e)


def init_git_repo() -> None:
    # git init (handle older git without -b)
    try:
        run(["git", "init", "-b", DEFAULT_BR])
    except subprocess.CalledProcessError:
        run(["git", "init"])
        run(["git", "checkout", "-b", DEFAULT_BR])

    run(["git", "add", "-A"])
    try:
        run(["git", "commit", "-m", "Initial commit from template"])
    except subprocess.CalledProcessError as e:
        print("WARN: git commit failed (likely user.name/email not set).")
        print(e)


def has_remote(name: str) -> bool:
    import subprocess
    return subprocess.run(["git", "remote", "get-url", name],
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE).returncode == 0

def create_github_repo():
    import subprocess
    vis = "--private" if PRIVATE_REPO else "--public"

    if has_remote("origin"):
        subprocess.run(["gh", "repo", "create", f"{GH_USER}/{REPO_NAME}", vis],
                       check=False)
        try:
            run(["git", "push", "-u", "origin", DEFAULT_BR])
        except Exception:
            pass
        return

    run([
        "gh", "repo", "create", f"{GH_USER}/{REPO_NAME}",
        "--source", ".", "--remote", "origin", "--push", vis
    ])
    try:
        run(["git", "push", "-u", "origin", DEFAULT_BR])
    except Exception:
        pass



def main():
    vp = None
    if SETUP_VENV:
        vp = ensure_venv()

    if vp:
        install_tools(vp)

    if INIT_GIT:
        init_git_repo()

    if CREATE_GH:
        try:
            create_github_repo()
        except Exception as e:
            print("WARN: GitHub repo creation failed:", e)


if __name__ == "__main__":
    main()
