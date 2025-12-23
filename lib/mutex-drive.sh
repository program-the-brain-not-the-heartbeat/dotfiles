#!/usr/bin/env bash
# drive-lib.sh - drive/mount helpers (depends on mutex-common.sh)
# shellcheck shell=bash

set -euo pipefail

# Locate + source mutex-common.sh
MUTEX_COMMON_PATH="${MUTEX_COMMON:-/usr/local/lib/mutex-common.sh}"
if [[ ! -f "$MUTEX_COMMON_PATH" ]]; then
  # fallback: same directory as this library file
  LIB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  [[ -f "$LIB_DIR/mutex-common.sh" ]] && MUTEX_COMMON_PATH="$LIB_DIR/mutex-common.sh"
fi
# shellcheck disable=SC1090
source "$MUTEX_COMMON_PATH" || { echo "❌ Missing helper library: $MUTEX_COMMON_PATH" >&2; exit 1; }

sanitize() {
  printf '%s' "${1:-}" \
    | tr '[:upper:]' '[:lower:]' \
    | tr '[:space:]' '-' \
    | tr -cd '[:alnum:]._+-' \
    | sed 's/^-\+//; s/-\+$//; s/-\{2,\}/-/g'
}

# Resolve a user argument (device|/mnt/name|name) to a mountpoint.
# Echoes mountpoint on success; echoes empty string if not found.
resolve_mountpoint() {
  local arg="${1:-}"
  local mp=""

  [[ -n "$arg" ]] || { echo ""; return 0; }

  if [[ -b "$arg" ]]; then
    mp="$(findmnt -nr -S "$arg" -o TARGET 2>/dev/null || true)"
  elif [[ -d "$arg" ]]; then
    mp="$arg"
  elif [[ -d "/mnt/$arg" ]]; then
    mp="/mnt/$arg"
  else
    mp="$(findmnt -nr -T "/mnt/$arg" -o TARGET 2>/dev/null || true)"
  fi

  mp="$(trim "$mp")"
  printf '%s' "$mp"
}

cleanup_empty_dir() {
  local dir="${1:-}"
  [[ -n "$dir" ]] || return 0
  [[ -d "$dir" ]] || return 0

  if rmdir "$dir" 2>/dev/null; then
    echo "🧹 Removed empty directory: $dir"
  fi
}
