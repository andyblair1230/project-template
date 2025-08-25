# Project automation commands (cross-platform via tasks.sh)
.PHONY: help setup fmt lint test run clean

help:
	@echo "Available commands:"
	@echo "  make setup  - install deps"
	@echo "  make fmt    - auto-format"
	@echo "  make lint   - check code style"
	@echo "  make test   - run tests"
	@echo "  make run    - run the project"
	@echo "  make clean  - remove build artifacts"

setup:
	./tasks.sh setup

fmt:
	./tasks.sh fmt

lint:
	./tasks.sh lint

test:
	./tasks.sh test

run:
	./tasks.sh run

clean:
	./tasks.sh clean
