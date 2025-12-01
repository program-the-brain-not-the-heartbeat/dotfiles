b() {
    # Usage: b journalctl -xe
    #        b crontab -l
    "$@" | bat
}
alias mount-missing='sudo awk '"'"'
  # Skip comments and empty lines
  $1 !~ /^#/ && NF >= 2 {
    device=$1
    mountpoint=$2
    # Check if mountpoint exists
    if (system("[ -d \"" mountpoint "\" ]") == 0) {
      # Check if already mounted
      if (system("findmnt -rno TARGET \"" mountpoint "\" >/dev/null 2>&1") != 0) {
        print "Mounting " device " on " mountpoint
        system("mount \"" mountpoint "\"")
      }
    }
  }
'"'"' /etc/fstab'
alias lf='ls -1f'
alias lsblk='lsblk -o NAME,MODEL,SIZE,FSTYPE,MOUNTPOINT'
alias lsblk+u='lsblk -o NAME,MODEL,SIZE,FSTYPE,LABEL,UUID,TYPE,MOUNTPOINT'
alias lsblk+t='lsblk -o NAME,TRAN,HOTPLUG,RO,SIZE,FSTYPE,LABEL,MODEL,MOUNTPOINT'
alias disks='lsblk -d -o NAME,TRAN,ROTA,SIZE,MODEL'
alias mnt='findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS,SIZE,USED,AVAIL'
alias mount='mount | grep -v "/docker/"'
alias uuid='blkid -o full'
alias uuids='blkid -o value -s UUID'
alias labels='lsblk -o NAME,LABEL,UUID'
usbdrives()   { lsblk -o NAME,TRAN,SIZE,MODEL | grep usb; }
nvmedrives()  { lsblk -o NAME,TRAN,SIZE,MODEL | grep nvme; }
satadrives()  { lsblk -o NAME,TRAN,SIZE,MODEL | grep sata; }
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
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
alias img="chafa --size=$(tput cols)x$(tput lines)"

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
alias mirror='wget --r --no-parent --no-clobber -e robots=off -R "index.html*" '
alias malwarescan='wordfence malware-scan --overwrite --output-format=csv --output-headers --output-path /root/wordfence-home.csv --match-engine=vectorscan /home'
alias malwarescan2='wordfence malware-scan --overwrite --output-format=csv --output-headers --output-path /root/wordfence-home.csv --match-engine=pcre /home'
og() { curl -s "https://opengraph.io/api/1.1/site/$1" | jq .; }
unshorten() {
    curl -ILs "$1" | grep -i "^location:"
}
alias e='${EDITOR:-nano}'
alias bat='batcat'
alias cat='bat --paging=never'
alias lsrem='lsblk -o NAME,HOTPLUG,TRAN,SIZE,MODEL,MOUNTPOINT | awk "$2==1"'
alias aliases='nano ~/.bash_aliases'
alias octal='stat -c "%a"'
alias ft='file -b'
alias inode='stat -c "%i"'
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"
pools() {
    local ver="${1:-$(ls /etc/php | sort -V | tail -n1)}"
    cd "/etc/php/$ver/fpm/pool.d/" || echo "Version $ver not installed currently on this system."
}
alias sites='cd /etc/nginx/sites-enabled'
alias sitesa='cd /etc/nginx/sites-available'
alias snippets='cd /etc/nginx/snippets'
nginx-logs() {
    cd /var/log/nginx/ || echo "nginx logs not found"
}

epoch() {
	local num=${1:--1}
	printf '%(%B %d, %Y %-I:%M:%S %p %Z)T\n' "$num"
}

rmhdr() {
    echo "Searching for filenames containing HDR in the $(pwd)..."

    mapfile -t matches < <(find . -type f -name '*HDR*')

    if (( ${#matches[@]} > 0 )); then
        printf '%s\n' "${matches[@]}"
    fi

    count="${#matches[@]}"

    if [[ "$count" -eq 0 ]]; then
        echo "No matching files found. Nothing to delete."
        return 0
    fi

    printf "\nDelete %d matching files? (Y/N): " "$count"
    read ans

    case "$ans" in
        [Yy]|[Yy][Ee][Ss])
            echo "Deleting $count files..."
            for f in "${matches[@]}"; do
                rm -f -- "$f"
            done
            echo "Done."
            ;;
        *)
            echo "Aborted. No files deleted."
            ;;
    esac
}

rmtrickplay() {
    echo "Searching for filenames ending in .trickplay in the $(pwd)..."

    mapfile -t matches < <(find . -type d -name '*.trickplay')

    if (( ${#matches[@]} > 0 )); then
        printf '%s\n' "${matches[@]}"
    fi

    count="${#matches[@]}"

    if [[ "$count" -eq 0 ]]; then
        echo "No matching files found. Nothing to delete."
        return 0
    fi

    printf "\nDelete %d matching files? (Y/N): " "$count"
    read ans

    case "$ans" in
        [Yy]|[Yy][Ee][Ss])
            echo "Deleting $count files..."
            for f in "${matches[@]}"; do
                rm -rf -- "$f"
            done
            echo "Done."
            ;;
        *)
            echo "Aborted. No files deleted."
            ;;
    esac
}

# TODO: functions for rclone, duplicacy, etc.
# TODO: Scripts for productivity and normal server admin
# TODO: Set facl, with mask, defaults, etc.
# TODO: Bitwarden Send

alias nrw='npm run watch'
alias nrp='npm run prod'
alias nrb='npm run build'
# TODO: VitePress

# TODO: GitHub shortcuts

# Test config and reload
reload-nginx() {
    sudo nginx -t && sudo systemctl reload nginx
}
alias r="fc -s"
mkcd() { mkdir -p "$1" && cd "$1" || return; }
ff() { find . -iname "*$1*"; }
cdf() { cd "$(find . -type d -iname "*$1*" | head -n 1)" || return; }
alias psmem='ps aux --sort=-%mem | head'
alias pscpu='ps aux --sort=-%cpu | head'
alias stripansi='sed -r "s/\x1B\[[0-9;]*[A-Za-z]//g"'
pass() { tr -dc 'A-Za-z0-9!@#$%^&*()_+=' </dev/urandom | head -c "${1:-16}"; echo; }
alias j='journalctl -xe'
alias h='history'
alias hgrep='history | grep -i'
alias cls='clear'
alias c='clear'
alias cl='clear && l'
alias h='history'
up() { local n=${1:-1}; while [ $n -gt 0 ]; do cd .. || return; n=$((n-1)); done; }
alias gg='grep -Rin --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias pd='cd -'
#alias -='cd -'
#alias /='cd /'
alias rsync-copy="rsync -av --progress -h --exclude-from=$HOME/.cvsignore"
alias rsync-move="rsync -av --progress -h --remove-source-files --exclude-from=$HOME/.cvsignore"
alias rsync-update="rsync -avu --progress -h --exclude-from=$HOME/.cvsignore"
alias rsync-synchronize="rsync -avu --delete --progress -h --exclude-from=$HOME/.cvsignore"

alias dc="docker compose"
alias dcd='docker compose down'
alias dcr='docker compose down && docker compose pull && docker compose up -d'
alias dcu='docker compose up -d'
alias nl='nl -ba'
alias md='mkdir -p'
alias rd='rmdir'
alias t='tail -n 50'
alias rmimages='find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.svg" -o -iname "*.webp" -o -iname "*.avif" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.tif" -o -iname "*.heic" -o -iname "*.heif" \) -delete'
alias rmempty='find . -type d -empty -delete'
alias rmnfo='find /vault/TV -type f -name "*.nfo" -print0 | xargs -0 rm -f'
rmrar() {
    local target="${1:-.}"

    # Safety: ensure directory exists
    if [[ ! -d "$target" ]]; then
        echo "rmrar: '$target' is not a directory" >&2
        return 1
    fi

    echo "Removing RAR parts and SFV files under: $target"

    find "$target" -type f \
        \( -iname "*.rar" \
        -o -regex '.*\.[rR][0-9][0-9]' \
        -o -regex '.*\.[rR][0-9][0-9][0-9]' \
        -o -iname "*.sfv" \) \
        -delete
}

rmsamples() {
    # Media extensions (edit as needed)
    local media_ext='\( \
        -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o \
        -iname "*.mov" -o -iname "*.mp3" -o -iname "*.flac" -o \
        -iname "*.wav" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \
    \)'

    # Find Sample / Samples directories
    find . -type d \( -iname "sample" -o -iname "samples" \) | while read -r d; do
        # Does this directory contain media?
        if eval find "\"$d\"" -type f "$media_ext" | grep -q .; then
            echo "Deleting: $d"
            rm -rf -- "$d"
        else
            echo "Skipping (no media): $d"
        fi
    done
}
alias cpv='rsync -ah --info=progress2'   # cp with progress
alias iplan='ip -4 addr show'
alias ipwan='curl -s ifconfig.me'
alias wanip='ipwan'
alias myip='curl -s ifconfig.me'
alias extip='curl icanhazip.com'
alias pingg='ping google.com'
alias please='sudo $(fc -ln -1)'   # Run last command with sudo
immutable() { sudo chattr -R +i -- "$@"; }
mutable()   { sudo chattr -R -i -- "$@"; }
alias authlog='sudo tail -n 100 /var/log/auth.log'
alias authgrep='sudo grep -i "failed password" /var/log/auth.log | tail'
alias sudolog='sudo grep -i "sudo:" /var/log/auth.log | tail'

fhash() {
    if [ -z "$1" ]; then
        echo "Usage: fhash <file>"
        return 1
    fi
    sha256sum "$1"
    sha1sum "$1"
    md5sum "$1"
}
facl() {
    if [ -z "$1" ]; then
        echo "Usage: facl <file|dir>"
        return 1
    fi
    getfacl -p "$1"
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
dbsizes() {
    mysql -N -e "SELECT table_schema AS db, ROUND(SUM(data_length+index_length)/1024/1024,1) AS mb
                 FROM information_schema.tables
                 GROUP BY table_schema ORDER BY mb DESC;"
}
alias php_limits='php -i | egrep "memory_limit|upload_max_filesize|post_max_size"'
alias php_fatals='sudo grep -i "PHP Fatal error" /var/log/nginx/error.log | tail'
alias tmuxa="tmux a -t"
alias tmuxs="tmux new -s"
alias cronall='sudo grep -R "" /etc/cron* /var/spool/cron/crontabs 2>/dev/null'
phplint() {
    find . -type f -name "*.php" -print0 | xargs -0 -n1 php -l
}
#mem() {
#    ps -eo rss,pid,euser,args:100 --sort %mem | grep --color=auto -v grep | grep --color=auto -i "$@" \
#        | awk '{printf $1/1024 " MB"; $1=""; print }'
#}
alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard'

alias cleanupmos="find . -type f -name '._*' -ls -delete"
alias recent1d='find . -mtime -1 -type f 2>/dev/null'
alias recent1h='find . -mmin -60 -type f 2>/dev/null'
alias untar='tar -xvf'
alias targz='tar -czvf'
alias zipr='zip -r'
alias unzipv='unzip -v'
alias cpu='lscpu'
alias mem='free -h'
alias disk='df -h'
alias ip='ip -c a'
alias reload='source ~/.bashrc'
alias ports='sudo lsof -i -P -n'                 # what’s using ports
alias whichport='sudo lsof -i -P -n | grep'
alias nodeports='sudo lsof -i -P -n | grep node'
alias port-pid='f() { sudo lsof -nP -iTCP:$1 -sTCP:LISTEN 2>/dev/null || echo "No process is listening on port $1"; }; f'
alias ports-all='echo "--- netstat ---"; ports-netstat; echo "--- ss ---"; ports-ss; echo "--- lsof ---"; ports-lsof'
alias ports-lsof='sudo lsof -i -P -n | grep LISTEN'
alias ports-lsof-full='sudo lsof -nP -iTCP -sTCP:LISTEN'
alias ports-netstat='sudo netstat -tuln | grep LISTEN'
alias ports-ss='ss -tuln'
alias ports-ss-full='sudo ss -tulnp'
alias proc-ports='f() {
  input="$1"
  if [[ -z "$input" ]]; then echo "Usage: proc-ports <process name or PID>"; return; fi

  if [[ "$input" =~ ^[0-9]+$ ]]; then
    pids="$input"
  else
    pids=$(pgrep -fi "$input")
  fi

  if [[ -z "$pids" ]]; then
    echo "No matching process found for \"$input\""
    return
  fi

  for pid in $pids; do
    if ! ps -p "$pid" > /dev/null 2>&1; then
      continue
    fi
    name=$(ps -p "$pid" -o comm=)
    output=$(sudo lsof -nP -iTCP -sTCP:LISTEN -a -p "$pid" 2>/dev/null)
    if [[ -n "$output" ]]; then
      echo "→ Listening ports for PID $pid ($name):"
      echo "$output"
    fi
  done

  if [[ -z "$output" ]]; then
    echo "No listening ports found for \"$input\""
  fi
}; f'
alias recent-malware-scan='find /home -cmin -720 -type f -print0 | wordfence malware-scan'
alias rsync2='rsync -ahP --exclude="/node_modules" --exclude="/.git" --exclude="*.env" --exclude="/logs" --chmod=Du=rwx,Dgo=rx,Fu=rw,Fog=r --no-perms --no-owner --no-group'
alias vulnscan='wordfence vuln-scan --output-format=csv --output-headers --output-columns=scanned_path,software_type,slug,version,id,title,link,description,cve,cvss_vector,cvss_score,cvss_rating,cwe_id,cwe_name,cwe_description,patched,remediation,published,updated  --output-path=/root/wordfence-vuln-home.csv /home'
alias disable-wordpress-debugging='bash -c '\''for const in WP_DEBUG WP_DEBUG_DISPLAY WP_DEBUG_LOG SAVEQUERIES SCRIPT_DEBUG; do wp @all config delete "$const" --type=constant || true; wp @all config set "$const" false --raw --type=constant; done'\'''

alias listen='sudo ss -tulnp'                    # services listening
alias hosts='sudo nano /etc/hosts'
alias bashrc='nano ~/.bashrc'
alias perms='stat -c "%A %a %n"'
alias rand='openssl rand -hex 16'
alias digg='dig +short'
alias big='du -ah . 2>/dev/null | sort -h | tail -n 20'
alias bigfiles='find . -type f -exec du -h {} + 2>/dev/null | sort -h | tail -n 20'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias update="sudo apt-get -qq update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"
alias path='echo "$PATH" | tr ":" "\n"'

alias fstab='cat /etc/fstab'
alias findapp='ps aux | grep -i'
alias killapp='sudo kill -9'
alias killappbyname='function _killapp(){ pkill -9 -f "$1"; }; _killapp'
alias weather='curl -s -A curl wttr.in | sed "$ d"'
alias w='curl -s wttr.in/?format=3'
alias ye='curl -s https://api.kanye.rest | jq -r .quote'
alias dadjoke='curl -s https://icanhazdadjoke.com/'
alias fact='curl -s https://uselessfacts.jsph.pl/random.json?language=en | jq -r .text'
define() {
    curl -s "https://api.dictionaryapi.dev/api/v2/entries/en/$1" | jq .
}
wiki() {
    curl -s "https://en.wikipedia.org/api/rest_v1/page/summary/$1" | jq -r .extract
}
countryinfo() {
    curl -s "https://restcountries.com/v3.1/name/$1" | jq .
}
alias wget-site='wget --mirror -p --convert-links -P'

function sr {
    if [[ ! -z $1 && ! -z $2 ]]; then
        wp search-replace $1 $2 --recurse-objects --all-tables --precise --allow-root
    fi

    if wp plugin is-installed elementor --quiet --allow-root && wp plugin is-active elementor --quiet --allow-root; then
        wp elementor flush_css --allow-root
    fi
}

function sre {
    if wp plugin is-installed elementor --quiet --allow-root && wp plugin is-active elementor --quiet --allow-root; then
        wp elementor flush_css --allow-root
    fi

    if [[ ! -z $1 && ! -z $2 ]]; then
        wp search-replace $1 $2 --skip-columns=guid --recurse-objects --precise --all-tables --allow-root --skip-plugins --skip-themes --export=db.sql
    fi
}

function wp() {
    /usr/local/bin/wp "$@" --allow-root
}

function wordfence() {
    /usr/bin/wordfence "$@" --no-banner --no-color
}

cd() { builtin cd "$@"; ls --color=auto; }
alias pwd=' pwd'
alias llm='ls -lhAt --group-directories-first' ## "m" for sort by last modified date
alias llc='ls -lhAU --group-directories-first' ## "c" for sort by creation date
alias lls='ls -lhAS --group-directories-first' ## "s" for sort by size

fixperms() {
    echo "You're about to recursively set permissions:"
    echo "  - Files to 0644"
    echo "  - Directories to 0755"
    echo "From this directory: $(pwd)"
    read -rp "Proceed? (Y/N): " answer

    case "${answer,,}" in
        y|yes)
            find . -type d -path "*/public" | while read -r public_path; do
                echo "📁 Processing: $public_path"
                find "$public_path" -type d -print0 | xargs -0 chmod 0755
                find "$public_path" -type f -print0 | xargs -0 chmod 0644
            done

            find . \( -path "*/public/wp-config.php" -o -path "*/wp-config.php" \) -type f -print0 | while IFS= read -r -d '' wpconfig; do
                echo "🔒 Securing $wpconfig"
                chmod 400 "$wpconfig"
            done

            echo "✅ Permissions fixed in public folders and wp-config.php secured."
            ;;
        *)
            echo "❌ Operation cancelled."
            ;;
    esac
}

function screamingfrogseospider() {
    /usr/bin/screamingfrogseospider "$@" --headless
}

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
timer() {
    start=$(date +%s)
    "$@"
    end=$(date +%s)
    echo "⏱️ Took $((end-start))s"
}
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.tar.xz)    tar xf "$1"    ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"     ;;
            *.7z)        7z x "$1"      ;;
            *.Z)         uncompress "$1";;
            *) echo "Unknown format: $1" ;;
        esac
    else
        echo "File not found: $1"
    fi
}
alias x='extract'
ipinfo() {
    # Decide target: $1 or wanip()
    if [ -z "$1" ]; then
        target="$(wanip)"
    else
        target="$1"
    fi

    # If it's not a bare IPv4, try to resolve it as a domain
    if ! printf '%s\n' "$target" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
        ip=$(dig +short "$target" | head -n 1)
        if [ -z "$ip" ]; then
            echo "Unable to resolve domain: $target" >&2
            return 2
        fi
    else
        ip="$target"
    fi

    # Query ipwho.is and pretty print JSON
    curl -s "https://ipwho.is/$ip" | jq .
}

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

alias mount-disk='mount-drive'

# Auto-detect FS, auto-name by bus+label/uuid/device, detect-already-mounted, optional remount
mount-drive() {
    if [ -z "$1" ]; then
        echo "Usage: mount-drive <device> [--dir <name>] [--remount] [--ro] [--opts \"k=v,...\"] [--suffix dev|none|auto]"
        return 1
    fi

    DEV="$1"; shift

    # Defaults
    REMOUNT=0
    READONLY=0
    CUSTOM_DIR=""
    EXTRA_OPTS=""
    SUFFIX_MODE="auto"   # auto|dev|none

    # Parse flags
    while [ $# -gt 0 ]; do
        case "$1" in
            --remount) REMOUNT=1 ;;
            --ro) READONLY=1 ;;
            --dir) CUSTOM_DIR="$2"; shift ;;
            --opts) EXTRA_OPTS="$2"; shift ;;
            --suffix) SUFFIX_MODE="$2"; shift ;;
            *) echo "Unknown option: $1" ; return 1 ;;
        esac
        shift
    done

    if [ ! -b "$DEV" ]; then
        echo "❌ Not a block device: $DEV"
        return 1
    fi

    _trim() { printf '%s' "$1" | tr -d '\r' | sed 's/^[[:space:]]\+//; s/[[:space:]]\+$//'; }

    DEV_BASENAME="$(basename "$DEV")"

    #
    # SAFETY: Do not allow mounting whole disk if it has partitions
    #
    DEV_TYPE="$(lsblk -ndo TYPE "$DEV" 2>/dev/null)"
    DEV_TYPE="$(_trim "$DEV_TYPE")"
    if [ "$DEV_TYPE" = "disk" ]; then
        PART_LINES="$(lsblk -nr -o NAME,TYPE,FSTYPE "$DEV" 2>/dev/null | awk '$2 == "part"')"
        if [ -n "$PART_LINES" ]; then
            echo "⚠️  Refusing to mount whole disk: $DEV"
            echo "    This disk has one or more partitions:"
            lsblk "$DEV"
            echo "    Please mount a specific partition instead (e.g. ${DEV}1, ${DEV}2, nvme0n1p1, etc.)."
            return 1
        fi
    fi

    # Detect FS, label, UUID (prefer lsblk, fall back to blkid)
    FSTYPE="$(lsblk -no FSTYPE "$DEV" 2>/dev/null)"
    FSTYPE="$(_trim "$FSTYPE")"
    [ -z "$FSTYPE" ] && FSTYPE="$(blkid -o value -s TYPE "$DEV" 2>/dev/null)"
    FSTYPE="$(_trim "$FSTYPE")"
    FSTYPE="${FSTYPE%%[[:space:]]*}"   # keep only first (avoid "exfat\nvfat")

    LABEL="$(lsblk -no LABEL "$DEV" 2>/dev/null)"
    LABEL="$(_trim "$LABEL")"
    LABEL="${LABEL%%[[:space:]]*}"
    [ -z "$LABEL" ] && LABEL="$(blkid -o value -s LABEL "$DEV" 2>/dev/null)"
    LABEL="$(_trim "$LABEL")"
    LABEL="${LABEL%%[[:space:]]*}"

    UUID="$(blkid -o value -s UUID "$DEV" 2>/dev/null)"
    UUID="$(_trim "$UUID")"

    # Detect bus type
    BUS="$(lsblk -no TRAN "$DEV" 2>/dev/null)"
    case "$BUS" in
        usb)   PREFIX="usb" ;;
        sata)  PREFIX="sata" ;;
        nvme)  PREFIX="nvme" ;;
        *)     PREFIX="disk" ;;
    esac
    BUS="$(_trim "$BUS")"

    # Determine base name: custom > label > uuid8 > device
    if [ -n "$CUSTOM_DIR" ]; then
        BASE_NAME="$CUSTOM_DIR"
    elif [ -n "$LABEL" ]; then
        BASE_NAME="$LABEL"
    elif [ -n "$UUID" ]; then
        BASE_NAME="$(printf '%s' "$UUID" | cut -c1-8)"
    else
        BASE_NAME="$DEV_BASENAME"
    fi

    # Sanitize
    _sanitize() {
        printf '%s' "$1" \
          | tr '[:upper:]' '[:lower:]' \
          | tr '[:space:]' '-' \
          | tr -cd '[:alnum:]._+-' \
          | sed 's/^-\+//; s/-\+$//; s/-\{2,\}/-/g'
    }

    BASE_NAME="$(_sanitize "$BASE_NAME")"
    [ -z "$BASE_NAME" ] && BASE_NAME="$(_sanitize "$DEV_BASENAME")"

    # Detect if partition
    is_partition=0
    case "$DEV_BASENAME" in
        *[0-9] | *p[0-9]) is_partition=1 ;;
    esac

    DEV_SUFFIX="$(_sanitize "$DEV_BASENAME")"

    case "$SUFFIX_MODE" in
        dev)   APPEND_SUFFIX=$is_partition ;;
        none)  APPEND_SUFFIX=0 ;;
        auto)  APPEND_SUFFIX=$is_partition ;;
        *)     APPEND_SUFFIX=$is_partition ;;
    esac

    NAME="$BASE_NAME"
    if [ "$APPEND_SUFFIX" -eq 1 ]; then
        if [ "$BASE_NAME" != "$DEV_SUFFIX" ] && [ "$BASE_NAME" != "${DEV_SUFFIX%-*}" ]; then
            NAME="${BASE_NAME}-${DEV_SUFFIX}"
        fi
    fi

    NAME="$(_sanitize "${NAME}")"
    MNT="/mnt/${PREFIX}-${NAME}"

    # Already mounted?
    CURRENT_MP="$(findmnt -nr -S "$DEV" -o TARGET 2>/dev/null)"
    if [ -n "$CURRENT_MP" ]; then
        if [ "$REMOUNT" -eq 1 ]; then
            OPTS="remount"
            [ "$READONLY" -eq 1 ] && OPTS="$OPTS,ro"
            [ -n "$EXTRA_OPTS" ] && OPTS="$OPTS,$EXTRA_OPTS"
            if sudo mount -o "$OPTS" "$CURRENT_MP"; then
                echo "🔁 Remounted $DEV (${FSTYPE:-unknown}) at $CURRENT_MP with: $OPTS"
                return 0
            else
                echo "❌ Failed to remount $DEV"
                return 1
            fi
        else
            echo "✅ Already mounted: $DEV → $CURRENT_MP"
            return 0
        fi
    fi

    # Ensure unique mountpoint
    if mountpoint -q "$MNT"; then
        OTHER_SRC="$(findmnt -nr -T "$MNT" -o SOURCE 2>/dev/null)"
        if [ "$OTHER_SRC" != "$DEV" ]; then
            MNT="/mnt/${PREFIX}-${NAME}-${DEV_SUFFIX}"
        fi
    fi

    sudo mkdir -p "$MNT" || return 1

    # Build mount options
    OPTS="rw"
    [ "$READONLY" -eq 1 ] && OPTS="ro"
    [ -n "$EXTRA_OPTS" ] && OPTS="$OPTS,$EXTRA_OPTS"

    # Choose FS driver
    case "$FSTYPE" in
        ntfs|ntfs3)
            if grep -qw ntfs3 /proc/filesystems; then TYPE="ntfs3"; else TYPE="ntfs"; fi
            ;;
        exfat) TYPE="exfat" ;;
        vfat|fat|fat32) TYPE="vfat" ;;
        xfs) TYPE="xfs" ;;
        btrfs) TYPE="btrfs" ;;
        ext2|ext3|ext4) TYPE="$FSTYPE" ;;
        ""|*) TYPE="${FSTYPE:-auto}" ;;
    esac

    # --- MOUNT OPERATION ---
    if sudo mount -t "$TYPE" -o "$OPTS" "$DEV" "$MNT"; then
        echo "📂 Mounted $DEV ($TYPE) → $MNT"
        findmnt -nr -S "$DEV"
        return 0
    else
        echo "❌ Failed to mount $DEV ($TYPE) at $MNT"

        # Cleanup empty mountpoint dir
        if [ -d "$MNT" ]; then
            if rmdir "$MNT" 2>/dev/null; then
                echo "🧹 Removed empty mountpoint directory: $MNT"
            else
                echo "⚠️ Could not remove $MNT (not empty or permission denied)"
            fi
        fi

        return 1
    fi
}

alias unmount-disk='umount-drive'
alias unmount-disk='umount-drive'
alias unmount='umount-drive'
alias unmount-drive='umount-drive'

umount-drive() {
    if [ -z "$1" ]; then
        echo "Usage: umount-drive <device|/mnt/name|name> [--lazy]"
        return 1
    fi

    _trim() {
        printf '%s' "$1" | tr -d '\r' | sed 's/^[[:space:]]\+//; s/[[:space:]]\+$//'
    }

    LAZY=0
    TARGET=""

    # Parse args: first non-flag is the target, flags after
    while [ $# -gt 0 ]; do
        case "$1" in
            --lazy|-l)
                LAZY=1
                ;;
            *)
                if [ -z "$TARGET" ]; then
                    TARGET="$1"
                else
                    echo "Unknown argument: $1"
                    return 1
                fi
                ;;
        esac
        shift
    done

    if [ -z "$TARGET" ]; then
        echo "Usage: umount-drive <device|/mnt/name|name> [--lazy]"
        return 1
    fi

    ARG="$TARGET"
    MP=""

    # Resolve to mountpoint
    if [ -b "$ARG" ]; then
        MP="$(findmnt -nr -S "$ARG" -o TARGET 2>/dev/null)"
    elif [ -d "$ARG" ]; then
        MP="$ARG"
    elif [ -d "/mnt/$ARG" ]; then
        MP="/mnt/$ARG"
    else
        MP="$(findmnt -nr -T "/mnt/$ARG" -o TARGET 2>/dev/null)"
    fi

    MP="$(_trim "$MP")"

    if [ -z "$MP" ]; then
        echo "❌ No mountpoint found for: $ARG"
        return 1
    fi

    if ! mountpoint -q "$MP"; then
        echo "ℹ️  $MP is not a mountpoint."
        return 0
    fi

    echo "🔎 Target mountpoint: $MP"

    UMOUNT_CMD=(sudo umount)
    [ "$LAZY" -eq 1 ] && UMOUNT_CMD+=( -l )

    # Try unmount; if it hangs, user can Ctrl+C, but we don't add timeout by default
    if "${UMOUNT_CMD[@]}" "$MP" 2>/tmp/umount-drive.err; then
        echo "🧹 Unmounted $MP"
        rm -f /tmp/umount-drive.err
        return 0
    else
        ERRMSG="$(cat /tmp/umount-drive.err 2>/dev/null || true)"
        rm -f /tmp/umount-drive.err
        echo "❌ Failed to unmount $MP"
        [ -n "$ERRMSG" ] && printf '%s\n' "$ERRMSG"
    fi

    echo "🔗 The mountpoint may be busy. Showing processes using $MP (if any):"
    if command -v lsof >/dev/null 2>&1; then
        sudo lsof +f -- "$MP" || echo "  (no lsof output)"
    elif command -v fuser >/dev/null 2>&1; then
        sudo fuser -vm "$MP" || echo "  (no fuser output)"
    else
        echo "  lsof/fuser not available."
    fi

    echo "💡 Tip: you can force a lazy unmount with:"
    echo "    umount-drive \"$ARG\" --lazy"
    return 1
}
