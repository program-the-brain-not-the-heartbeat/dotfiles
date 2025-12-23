# TODO: functions for rclone, duplicacy, etc.
# TODO: Scripts for productivity and normal server admin
# TODO: Set facl, with mask, defaults, etc.
# TODO: Bitwarden Send

# Additional productivity aliases
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# Only override specific commands when not inside a VSCode terminal
if ! is_vscode; then
    cd() { builtin cd "$@"; ls --color=auto; }

    alias cat='bat --paging=never'

    alias bat='batcat'
fi


alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias octal='stat -c "%a"'
alias perms='stat -c "%A %a %n"'
alias ft='file -b'
alias inode='stat -c "%i"'

alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias pd='cd -'
#alias -='cd -'
#alias /='cd /'

alias s='head -n 50'
alias t='tail -n 50'

pass() { tr -dc 'A-Za-z0-9!@#$%^&*()_+=' </dev/urandom | head -c "${1:-16}"; echo; }
alias rand='openssl rand -hex 16'


alias recent1d='find . -mtime -1 -type f 2>/dev/null'
alias recent1h='find . -mmin -60 -type f 2>/dev/null'

alias crons='sudo grep -R "" /etc/cron* /var/spool/cron/crontabs 2>/dev/null'

# Custom aliases for /sbin/mount-disk and /sbin/umount-disk
alias mount-disk='mount-drive'
alias unmount-disk='umount-drive'
alias unmount-disk='umount-drive'
alias unmount='umount-drive'
alias unmount-drive='umount-drive'

alias llm='ls -lhAt --group-directories-first' ## "m" for sort by last modified date
alias lls='ls -lhAS --group-directories-first' ## "s" for sort by size
alias lf='ls -1f'


alias please='sudo $(fc -ln -1)'   # Run last command with sudo
alias r="fc -s"

alias tmuxa="tmux a -t"
alias tmuxs="tmux new -s"

alias nl='nl -ba'


b() {
    # Usage: b journalctl -xe
    #        b crontab -l
    "$@" | bat
}

# Deprecated: use 'rootgrep' instead, faster
#rootgrep() {
#  sudo find / \
#    \( -path /proc -o -path /sys -o -path /dev -o -path /run -o -path /tmp -o -path /var/lib/docker -o -path /snap -o -path /mnt -o -path /media \) -prune -o \
#    -type f -exec grep -nH --binary-files=without-match "$@" {} +
#}
alias rootgrep='sudo rg -ttext "$@" /'
alias gg='grep -Rin --color=auto'

# Strip control characters / ANSI escape codes from input
alias stripansi='sed -r "s/\x1B\[[0-9;]*[A-Za-z]//g"'

# View image inside the a ssh terminal
alias img="chafa --size=$(tput cols)x$(tput lines)"


alias aliases='nano ~/.bash_aliases'
alias bashrc='nano ~/.bashrc'
alias reload='source ~/.bashrc'
dotfiles() { bash <(curl -fsSL https://raw.githubusercontent.com/program-the-brain-not-the-heartbeat/dotfiles/main/bootstrap.sh) --yes; }

timer() {
    start=$(date +%s)
    "$@"
    end=$(date +%s)
    echo "⏱️ Took $((end-start))s"
}

# Quick shortcuts
alias e='${EDITOR:-nano}'
alias j='journalctl -xe'
alias h='history'
alias hgrep='history | grep -i'
alias cls='clear'
alias c='clear'
alias cl='clear && l'

# Other aliases

alias weather='curl -s -A curl wttr.in | sed "$ d"'
alias w='curl -s wttr.in/?format=3'
alias ye='curl -s https://api.kanye.rest | jq -r .quote'
alias dadjoke='curl -s https://icanhazdadjoke.com/ && echo'
alias fact='curl -s https://uselessfacts.jsph.pl/random.json?language=en | jq -r .text'
define() {
    curl -s "https://api.dictionaryapi.dev/api/v2/entries/en/$1" | jq .
}
wiki() {
    curl -s "https://en.wikipedia.org/api/rest_v1/page/summary/$1" | jq -r .extract
}


cpe() {
    if [[ $# -ne 2 || "$1" == "--help" || "$1" == "-h" ]]; then
cat <<EOF
Usage: ${FUNCNAME[0]} <source> <destination>

Description:
  Copy a file to a new destination and immediately open it in your default
  editor for quick editing. Useful for cloning config files before applying changes.

Arguments:
  <source>        Path to the file to copy from
  <destination>   Path where the copied file will be created

Examples:
  ${FUNCNAME[0]} /etc/nginx/nginx.conf /tmp/nginx.conf
  ${FUNCNAME[0]} /etc/php/8.0/fpm/php.ini /etc/php/8.3/fpm/php.ini

EOF
        return [[ $# -ne 2 ]] && echo 1 || echo 0
    fi

    local src="$1"
    local dest="$2"

    cp -- "$src" "$dest" || return 1
    cd "$(dirname -- "$dest")" || return 1
    "${VISUAL:-${EDITOR:-nano}}" "$(basename -- "$dest")"
}

wwwdata() {
    shopt -s nullglob
    sudo chown -c -R www-data:www-data -- * .[!.]* .[!.]?*
}

matt() {
    shopt -s nullglob
    sudo chown -c -R matt:matt -- * .[!.]* .[!.]?*
}



alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"
