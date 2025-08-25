# hooks/pre_gen_project.py
import sys
from pathlib import Path
import re

repo_name = "{{ cookiecutter.repo_name }}"
if not re.match(r"^[a-zA-Z0-9._-]+$", repo_name):
    print(
        f"ERROR: repo_name '{repo_name}' contains invalid characters.", file=sys.stderr
    )
    sys.exit(1)

target = Path.cwd() / repo_name
if target.exists():
    print(
        f"ERROR: Directory '{repo_name}' already exists. Choose a different repo_name.",
        file=sys.stderr,
    )
    sys.exit(1)
