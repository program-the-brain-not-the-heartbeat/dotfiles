#!/usr/bin/env bash
# script-lib.sh - generic helpers for shell scripts
# shellcheck shell=bash

set -euo pipefail

usage_die() {
  # usage_die "message" [exit_code]
  local msg="${1:-}"
  local code="${2:-1}"
  [[ -n "$msg" ]] && echo "❌ $msg" >&2
  exit "$code"
}

die() {
  echo "❌ $*" >&2
  exit 1
}

warn() {
  echo "⚠️ $*" >&2
}

info() {
  echo "ℹ️  $*"
}

trim() {
  printf '%s' "${1:-}" | tr -d '\r' | sed 's/^[[:space:]]\+//; s/[[:space:]]\+$//'
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

mktemp_file() {
  # mktemp_file [/tmp/prefix.XXXXXX]
  local template="${1:-/tmp/tmpfile.XXXXXX}"
  mktemp "$template"
}
