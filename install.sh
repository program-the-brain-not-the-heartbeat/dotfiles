#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

mkdir -p "$HOME/.config/wget" "$HOME/.config/curl"
mkdir -p "$HOME/.config/nano"
mkdir -p "$HOME/.local/share/nano/backups"

ln -sf "$DOTFILES/config/wgetrc" "$HOME/.config/wget/wgetrc"
ln -sf "$DOTFILES/config/curlrc" "$HOME/.config/curl/.curlrc"


# Nano
ln -sf "$DOTFILES/config/nano/nanorc" "$HOME/.nanorc"
ln -sf "$DOTFILES/config/nano/catppuccin-mocha.nanorc" "$HOME/.config/nano/catppuccin-mocha.nanorc"
