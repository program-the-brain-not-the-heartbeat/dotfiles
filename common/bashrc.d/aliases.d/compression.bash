# File compression
alias untar='tar -xvf'
alias targz='tar -czvf'
alias zipr='zip -r'
alias unzipv='unzip -v'


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
