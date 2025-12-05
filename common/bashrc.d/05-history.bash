# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

export HISTTIMEFORMAT="%F %T "

# function historymerge {
#     history -n; history -w; history -c; history -r;
# }
# trap historymerge EXIT
# PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
