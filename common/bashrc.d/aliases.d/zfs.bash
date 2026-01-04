snapshots() {
    zfs list -t snapshot -r "${1:-tank}"
}

rmsnapshots() {
    local POOL="$1"
    local DAYS="${2:-30}"

    zfs list -t snapshot -r "$POOL" -H -o name,creation | while read -r SNAP CREATED_AT; do
        if [[ "$(date -d "$CREATED_AT" +%s)" -lt "$(date -d "$DAYS days ago" +%s)" ]]; then
            zfs destroy "$SNAP"
        fi
    done
}
