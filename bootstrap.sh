#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/program-the-brain-not-the-heartbeat/dotfiles.git"
TARGET_DIR="${HOME}/dotfiles"   # change if you prefer ~/.dotfiles etc.

echo ">>> Using target directory: $TARGET_DIR"

if command -v git >/dev/null 2>&1; then
  echo ">>> git found."
else
  echo "ERROR: git is not installed or not in PATH. " >&2
  exit 1
fi

if [ -d "$TARGET_DIR/.git" ]; then
  echo ">>> Repo already exists, pulling latest changes..."
  git -C "$TARGET_DIR" pull --ff-only
elif [ -d "$TARGET_DIR" ]; then
  echo "ERROR: $TARGET_DIR exists but is not a git repo. Remove or choose a different TARGET_DIR." >&2
  exit 1
else
  echo ">>> Cloning $REPO_URL into $TARGET_DIR..."
  git clone "$REPO_URL" "$TARGET_DIR"
fi

INSTALL_SCRIPT="$TARGET_DIR/install.sh"

if [ ! -f "$INSTALL_SCRIPT" ]; then
  echo "ERROR: install.sh not found in $TARGET_DIR" >&2
  exit 1
fi

chmod +x "$INSTALL_SCRIPT"

echo ">>> Ready to run: $INSTALL_SCRIPT"
read -r -p "Run install.sh now? [y/N] " CONFIRM

case "$CONFIRM" in
  [yY][eE][sS]|[yY])
    echo ">>> Running install.sh..."
    "$INSTALL_SCRIPT"
    ;;
  *)
    echo ">>> Skipping install.sh. You can run it later with:"
    echo "    $INSTALL_SCRIPT"
    ;;
esac
