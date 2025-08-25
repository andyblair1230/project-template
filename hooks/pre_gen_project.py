import sys
import os
name = "{{ cookiecutter.repo_name }}"
if os.path.exists(name):
    print(f"ERROR: Directory '{name}' already exists. Choose a different repo_name.")
    sys.exit(1)
