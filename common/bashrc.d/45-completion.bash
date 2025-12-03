

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# >>> b2 autocomplete >>>
# This section is managed by b2 . Manual edit may break automated updates.
source /root/.bash_completion.d/b2 || true
# <<< b2 autocomplete <<<


[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
