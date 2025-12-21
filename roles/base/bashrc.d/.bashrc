# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export DOTFILES_ROLE="${DOTFILES_ROLE:-base}"
export DOTFILES_ROOT="${HOME}/dotfiles"

# Load base snippets
for f in "${DOTFILES}/common/bashrc.d/"*.bash; do
    [ -r "$f" ] && . "$f"
done

# Load role-specific snippets
if [ -n "${DOTFILES_ROLE}" ] && [ "${DOTFILES_ROLE}" != "base" ]; then
    for f in "${DOTFILES_ROOT}/roles/${DOTFILES_ROLE}/bashrc.d/"*.bash; do
        [ -r "$f" ] && . "$f"
    done
fi

# Optional machine-local overrides
if [ -f "${HOME}/.bashrc.local" ]; then
    . "${HOME}/.bashrc.local"
fi
