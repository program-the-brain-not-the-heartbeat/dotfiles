#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# Load base snippets
for f in "${DOTFILES}/common/bashrc.d/"*.bash; do
    [ -r "$f" ] && . "$f"
done

###############################################
# link_file SOURCE TARGET
# Safely create/update a symlink.
# - Backs up real files
# - Replaces old/broken symlinks
# - Idempotent: safe to run repeatedly
###############################################
link_file() {
    if [[ $# -gt 2 ]]; then
        local target_dir="$1"; shift
        mkdir -p "$target_dir"
        for src in "$@"; do
            link_file "$src" "$target_dir/$(basename "$src")"
        done
        return
    fi

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


sudo apt update -qq
sudo apt install -y -qq git jq bat curl wget htop nano tmux
sudo groupadd admins || true
sudo groupadd developers || true





mkdir -p /opt/scripts/matt
chown -R matt:matt /opt/scripts/matt
chmod -R 750 /opt/scripts/matt
setfacl -m g:admins:rX /opt/scripts/matt || true
chmod 750 /opt/scripts
chmod 755 /opt
chown root:root /opt
chown root:admins /opt/scripts

UMASK_FILE="/etc/profile.d/umask.sh"
UMASK_VALUE="022"

echo "Setting global default umask to ${UMASK_VALUE}..."
cat <<EOF | sudo tee "${UMASK_FILE}" >/dev/null
umask ${UMASK_VALUE}
EOF

sudo chmod 644 "${UMASK_FILE}" || true

echo "✅ ${UMASK_FILE} installed"


mkdir -p "$HOME/.config/wget" "$HOME/.config/curl"
mkdir -p "$HOME/.config/nano"
mkdir -p "$HOME/.local/share/nano/backups"
mkdir -p "$HOME/.ssh/config.d"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/htop"

# Bash
link_file "$DOTFILES/roles/base/bashrc.d/.bashrc" "$HOME/.bashrc"
link_file "$DOTFILES/config/.dircolors" "$HOME/.dircolors"

aliases="$HOME/.bash_aliases"
: > "$aliases"

for f in "$DOTFILES/common/bashrc.d/aliases.d/"*.bash; do
  [ -f "$f" ] || continue
  cat "$f" >> "$aliases"
  echo >> "$aliases"
done

# SSH configuration
link_file "$DOTFILES/config/ssh/config" "$HOME/.ssh/config"
#link_file "$HOME/.ssh/conf.d" "$DOTFILES/config/.ssh/conf.d/"*

# Application configuration files
link_file "$DOTFILES/config/wgetrc" "$HOME/.config/wget/wgetrc"
link_file "$DOTFILES/config/curlrc" "$HOME/.config/curl/.curlrc"
link_file "$DOTFILES/config/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES/config/htop/htoprc" "$HOME/.config/htop/htoprc"

# tmux
link_file "$DOTFILES/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

if [[ ! -f "$HOME/.tmux.conf" ]]; then
  printf 'source-file ~/.config/tmux/tmux.conf\n' > "$HOME/.tmux.conf"
fi

# Nano
link_file "$DOTFILES/config/nano/.nanorc" "$HOME/.nanorc"
link_file "$DOTFILES/config/nano/catppuccin-mocha.nanorc" "$HOME/.config/nano/catppuccin-mocha.nanorc"


if [[ -n "${BASH_VERSION:-}" && -f "$HOME/.bash_aliases" ]]; then
     # shellcheck disable=SC1090
    source "$HOME/.bashrc"
    source "$HOME/.bash_aliases"
fi

echo "Done installing."
