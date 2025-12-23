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
