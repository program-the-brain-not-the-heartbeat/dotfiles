#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

###############################################
# link_file SOURCE TARGET
# Safely create/update a symlink.
# - Backs up real files
# - Replaces old/broken symlinks
# - Idempotent: safe to run repeatedly
###############################################
link_file() {
    local source="$1"
    local target="$2"

    echo "→ Linking $target → $source"

    # If target exists and is not a symlink, back it up
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "  Existing file detected — backing up to ${target}.backup.$(date +%s)"
        mv "$target" "${target}.backup.$(date +%s)"
    fi

    # If target is a symlink (valid or broken), remove it
    if [[ -L "$target" ]]; then
        echo "  Removing existing symlink..."
        rm -f "$target"
    fi

    # Create symlink
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"

    echo "  ✔ Linked successfully"
}

mkdir -p "$HOME/.config/wget" "$HOME/.config/curl"
mkdir -p "$HOME/.config/nano"
mkdir -p "$HOME/.local/share/nano/backups"

# Bash
link_file "$DOTFILES/.bash_aliases" "$HOME/.bash_aliases"
link_file "$DOTFILES/config/.dircolors" "$HOME/.dircolors"

# Application configuration files
link_file "$DOTFILES/config/wgetrc" "$HOME/.config/wget/wgetrc"
link_file "$DOTFILES/config/curlrc" "$HOME/.config/curl/.curlrc"
link_file "$DOTFILES/config/.gitconfig" "$HOME/.gitconfig"


# Nano
link_file "$DOTFILES/config/nano/nanorc" "$HOME/.nanorc"
link_file "$DOTFILES/config/nano/catppuccin-mocha.nanorc" "$HOME/.config/nano/catppuccin-mocha.nanorc"

if [[ -n "${BASH_VERSION:-}" && -f "$HOME/.bash_aliases" ]]; then
     # shellcheck disable=SC1090
    source "$HOME/.bash_aliases"
fi
