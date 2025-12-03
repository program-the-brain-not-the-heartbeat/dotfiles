export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias chmod='function _chmod() { if [[ "$1" == "777" ]]; then echo "chmod 777 is disabled."; else /bin/chmod "$@"; fi; }; _chmod'
