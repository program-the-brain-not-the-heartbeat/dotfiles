# File permissions
alias mx='chmod u+x'
alias 400='chmod 400 -c -R'
alias 600='chmod 600 -c -R'
alias 640='chmod 640 -c -R'
alias 644='chmod 644 -c -R'
alias 644f='find . -type f -print0 | xargs -0 chmod 0644'
alias 755='chmod 755 -c -R'
alias 755d='find . -type d -print0 | xargs -0 chmod 0755'
alias 775='chmod 775 -c -R'
alias 777='chmod 777 -c -R'
alias fixacls='find . -type d -exec setfacl -m u:www-data:rx {} \;'

alias md='mkdir -p'
alias rd='rmdir'


alias big='du -ah . 2>/dev/null | sort -h | tail -n 20'
#alias big='du -ah . | sort -rh | head -20'
alias bigfiles='find . -type f -exec du -h {} + 2>/dev/null | sort -h | tail -n 20'
#alias big-files='ls -1Rhs | sed -e "s/^ *//" | grep "^[0-9]" | sort -hr | head -n20'

alias cleanupmos="find . -type f -name '._*' -ls -delete"

# Dont clutter bash history
alias pwd=' pwd'
alias cwd=' pwd | tr -d "\r\n" | xclip -selection clipboard'

# Go back <#> of directories (e.g. up 3)
up() { local n=${1:-1}; while [ $n -gt 0 ]; do cd .. || return; n=$((n-1)); done; }

# Jump into the first directory that matches a name
cdf() { cd "$(find . -type d -iname "*$1*" | head -n 1)" || return; }


mkcd() { mkdir -p "$1" && cd "$1" || return; }
ff() { find . -iname "*$1*"; }

df() {
    if [ $# -eq 0 ]; then
        command df -h | grep -v "/docker/"
    else
        command df "$@"
    fi
}
bak() {
    cp "$1" "$1.$(date +%Y%m%d-%H%M%S).bak"
}
alias cpu='lscpu'
alias mem='free -h'
alias memusage='sudo ps -e -orss=,args= | sort -b -k1,1n'
alias psmem='ps aux --sort=-%mem | head'
alias pscpu='ps aux --sort=-%cpu | head'

#mem() {
#    ps -eo rss,pid,euser,args:100 --sort %mem | grep --color=auto -v grep | grep --color=auto -i "$@" \
#        | awk '{printf $1/1024 " MB"; $1=""; print }'
#}
alias disk='df -h'


alias fstab='cat /etc/fstab'
alias findapp='ps aux | grep -i'
alias killapp='sudo kill -9'
alias killappbyname='function _killapp(){ pkill -9 -f "$1"; }; _killapp'

alias path='echo "$PATH" | tr ":" "\n"'
created() {
  for file in "$@"; do
    local btime
    btime=$(stat -c %w -- "$file")
    date -d "$btime" "+%Y-%m-%d %H:%M:%S" | awk -v f="$file" '{print $0 "  " f}'
  done
}
birth() {
  for file in "$@"; do
    stat -c %w -- "$file" \
      | xargs -I{} date -d "{}" "+%Y-%m-%d %H:%M:%S"
  done
}
facl() {
    if [ -z "$1" ]; then
        echo "Usage: facl <file|dir>"
        return 1
    fi
    getfacl -p "$1"
}

immutable() { sudo chattr -R +i -- "$@"; }
mutable()   { sudo chattr -R -i -- "$@"; }

fhash() {
    if [ -z "$1" ]; then
        echo "Usage: fhash <file>"
        return 1
    fi
    sha256sum "$1"
    sha1sum "$1"
    md5sum "$1"
}
lockdown() {
    sudo chmod -R o-rwx -- * .[^.]*
}
unlockdown() {
    sudo chmod -R o+rx -- * .[^.]*
}
dirhash() {
    find . -type f -print0 | xargs -0 sha256sum
}
comparehash() {
    if [ $# -ne 1 ]; then
        echo "Usage: comparehash <hashfile>"
        return 1
    fi
    sha256sum -c "$1"
}


# Log viewing
alias authlog='sudo tail -n 100 /var/log/auth.log'
alias authgrep='sudo grep -i "failed password" /var/log/auth.log | tail'
alias sudolog='sudo grep -i "sudo:" /var/log/auth.log | tail'


# Systemd administration
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias status='systemctl status'
alias enable='sudo systemctl enable'
alias disable='sudo systemctl disable'
alias reload-services='sudo systemctl daemon-reexec'
alias timers='systemctl list-timers --all'
alias tgrep='systemctl list-timers --all | grep -i'
alias sgrep='systemctl list-units --type=service --all | grep -i'

# Grep systemd unit files
ugrep() {
    systemctl list-unit-files --all | grep -i "$1"
}

# View timer status and unit file
timer() {
    systemctl status "$1.timer"
    systemctl cat "$1.timer"
}

# View service status and unit file
svc() {
    systemctl status "$1.service"
    systemctl cat "$1.service"
}

# Edit a systemd service
edit-service() {
    sudo systemctl edit "$@"
}

# Restart a systemd service
restart() {
    sudo systemctl restart "$@"
}
