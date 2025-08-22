# Project automation commands

.PHONY: help test lint run clean

help:
	@echo "Available commands:"
	@echo "  make test   - run tests"
	@echo "  make lint   - check code style"
	@echo "  make run    - run the project"
	@echo "  make clean  - remove build artifacts"

test:
    pytest -q

lint:
    ruff check .

run:
    python -m src

clean:
    del /Q /S dist build *.pyc
