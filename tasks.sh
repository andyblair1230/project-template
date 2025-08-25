#!/usr/bin/env bash
set -euo pipefail

cmd="${1:-help}"

exists() { test -f "$1"; }
has() { command -v "$1" >/dev/null 2>&1; }

case "$cmd" in
  setup)
    if exists pyproject.toml && has python; then python -m pip install -U pip || true; pip install -e ".[dev]" || pip install -r requirements.txt || true; fi
    if exists package.json && has npm; then npm ci || npm install; fi
    if exists go.mod && has go; then go mod tidy; fi
    if exists Cargo.toml && has cargo; then cargo fetch; fi
    ;;
  fmt)
    if exists pyproject.toml; then black . || true; ruff check --fix . || true; fi
    if exists package.json; then npm run fmt || true; fi
    if exists go.mod; then go fmt ./... || true; fi
    if exists Cargo.toml; then cargo fmt || true; fi
    ;;
  lint)
    if exists pyproject.toml; then ruff check . || true; mypy . || true; fi
    if exists package.json; then npm run lint || true; fi
    if exists go.mod && has golangci-lint; then golangci-lint run || true; fi
    if exists Cargo.toml; then cargo clippy -D warnings || true; fi
    ;;
  test)
    if exists pyproject.toml; then pytest -q || true; fi
    if exists package.json; then npm test --silent || true; fi
    if exists go.mod; then go test ./... || true; fi
    if exists Cargo.toml; then cargo test || true; fi
    ;;
  *)
    echo "usage: ./tasks.sh {setup|fmt|lint|test}"
    exit 1
    ;;
  run)
    if [ -f pyproject.toml ]; then python -m src || true; fi
    if [ -f package.json ]; then npm start || true; fi
    if [ -f go.mod ]; then go run ./cmd/... || true; fi
    if [ -f Cargo.toml ]; then cargo run || true; fi
    ;;
  clean)
    rm -rf dist build .pytest_cache **/__pycache__ || true
    find . -type f -name '*.pyc' -delete 2>/dev/null || true
    ;;
esac
