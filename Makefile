.DEFAULT_GOAL:=help  # because it's is a safe task.

clean: # Remove the environment.
	rm -rf .venv
	rm -rf *.egg-info
	find . -name "*.pyc" -exec rm -f {} \;
	find . -type f -name "*.py[co]" -delete -or -type d -name "__pycache__" -delete

lock:  # Create the lock file and requirements file.
	rm -f requirements.txt
	uv pip compile pyproject.toml --python .venv/bin/python --output-file=requirements.txt

.PHONY: help
help: # Show help for each of the makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

lint:  # Lint the code with ruff.
	.venv/bin/ruff check ./src ./tests ./scripts

lock:  # Update the lock file from pyproject.toml.
	uv lock

report:  # Report the python version and pip list.
	.venv/bin/python --version
	uv pip list -v

venv:  # Create the virtual environment.
	uv venv .venv --clear
	uv sync --frozen
