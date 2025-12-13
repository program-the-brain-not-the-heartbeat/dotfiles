if [ -d "$HOME/.bash_completion.d" ]; then
  for f in "$HOME/.bash_completion.d/"*; do
    [ -r "$f" ] && source "$f" || true
  done
fi


if [[ -n "$NVM_DIR" ]]; then
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

#restic generate --bash-completion ~/.bash_completion.d/restic



# This is probably not needed below
# >>> b2 autocomplete >>>
# This section is managed by b2 . Manual edit may break automated updates.
source /root/.bash_completion.d/b2 || true
# <<< b2 autocomplete <<<
