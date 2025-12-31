# File compression
alias untar='tar -xvf'
alias targz='tar -czvf'
alias zipr='zip -r'
alias unzipv='unzip -v'


extract() {
    [[ -f "$1" ]] || { echo "File not found: $1" >&2; return 1; }

    case "$1" in
        *.tar.bz2|*.tbz2)  tar -xjf "$1" ;;
        *.tar.gz|*.tgz)   tar -xzf "$1" ;;
        *.tar.xz)         tar -xJf "$1" ;;
        *.tar.zst)        tar --zstd -xf "$1" ;;
        *.tar.lz4)        lz4 -dc "$1" | tar -xf - ;;
        *.tar.lzma)       tar --lzma -xf "$1" ;;
        *.tar)            tar -xf "$1" ;;
        *.bz2)            bunzip2 -q "$1" ;;
        *.gz)             gunzip -q "$1" ;;
        *.xz)             unxz -q "$1" ;;
        *.zst)            unzstd -q "$1" ;;
        *.lz4)            lz4 -dq "$1" ;;
        *.lzma)           unlzma -q "$1" ;;
        *.rar)            unrar x -y -idq "$1" ;;
        *.zip|*.apk|*.jar|*.war) unzip -q "$1" ;;
        *.7z)             7z x -y -bd "$1" ;;
        *.cab)            cabextract -q "$1" ;;
        *.deb)            ar x "$1" ;;
        *.rpm)            rpm2cpio "$1" | cpio -id --quiet ;;
        *.Z)              uncompress -q "$1" ;;
        *)
            echo "Unknown format: $1" >&2
            return 2
            ;;
    esac
}
alias x='extract'
