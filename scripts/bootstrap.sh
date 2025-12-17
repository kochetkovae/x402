#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "✅ x402 bootstrap starting..."

# JS/TS dependencies (repo has package.json + pnpm-lock.yaml)
if command -v pnpm >/dev/null 2>&1; then
  echo "📦 Installing JS/TS dependencies with pnpm..."
  pnpm install
elif command -v npm >/dev/null 2>&1; then
  echo "📦 pnpm not found; installing JS/TS dependencies with npm..."
  npm ci || npm install
else
  echo "⚠️ Neither pnpm nor npm found; skipping JS/TS install."
fi

# Go dependencies (repo has /go)
if [ -d "$ROOT_DIR/go" ] && command -v go >/dev/null 2>&1; then
  echo "🐹 Downloading Go modules..."
  (cd "$ROOT_DIR/go" && go mod download)
fi

# Python dependencies are intentionally not installed automatically
echo "ℹ️ Python setup is not automated here; see /python for instructions."

echo "✅ Bootstrap complete."
