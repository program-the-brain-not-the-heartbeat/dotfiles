# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

umask 022

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --time-style=long-iso'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export PS1="$PS1\[\e]1337;CurrentDir="'$(pwd)\a\]'

if command -v batcat >/dev/null 2>&1; then
    # Default pager: batcat (plain style, always page)
    # This will affect tools that honor $PAGER (git, etc.)
    export PAGER="batcat --decorations=always --color=always"

    # Systemd tools (journalctl, systemctl, etc.)
    # They use SYSTEMD_PAGER first; point it to batcat as well.
    export SYSTEMD_PAGER="$PAGER"

    # Man pages through batcat
    # col -bx strips backspaces and formatting, -l man for syntax
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

    # Optional: how batcat itself pages *its* output
    # (batcat pipes into BAT_PAGER, default is less)
    export BAT_PAGER="less -FR"
fi

# some more ls aliases
alias ll='ls -lahF --time-style=long-iso --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

LOCAL_BIN="$HOME/.local/bin"

[ -d "$LOCAL_BIN" ] || mkdir -p "$LOCAL_BIN" && chmod 700 "$LOCAL_BIN"

case ":$PATH:" in
  *":$LOCAL_BIN:"*) ;;
  *) export PATH="$PATH:$LOCAL_BIN" ;;
esac

export PATH=~/.composer/vendor/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> b2 autocomplete >>>
# This section is managed by b2 . Manual edit may break automated updates.
source /root/.bash_completion.d/b2 || true
# <<< b2 autocomplete <<<

export LC_BYOBU=0
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export WP_CLI_CONFIG_PATH=/etc/wp-cli/wp-cli.yml
export WP_CLI_PACKAGES_DIR=/etc/wp-cli/packages/
export WP_CLI_CACHE_DIR=/etc/wp-cli/cache/
