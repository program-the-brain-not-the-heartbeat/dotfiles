#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

mkdir -p "$HOME/.config/wget" "$HOME/.config/curl"

ln -sf "$DOTFILES/config/wgetrc" "$HOME/.config/wget/wgetrc"
ln -sf "$DOTFILES/config/curlrc" "$HOME/.config/curl/.curlrc"


