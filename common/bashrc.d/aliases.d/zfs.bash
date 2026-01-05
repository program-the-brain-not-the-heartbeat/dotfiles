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

snapshot() {
  local spec="$1"
  local dataset snap mp

  if [[ -z "$spec" ]]; then
    echo "Usage: snapshot <dataset@snapname> [path]" >&2
    echo "Example: snapshot vault@zfs-auto-snap_daily-2025-11-25-1025" >&2
    echo "Example: snapshot vault@zfs-auto-snap_daily-2025-11-25-1025 etc/cron.d" >&2
    return 2
  fi

  # Require dataset@snap format
  if [[ "$spec" != *@* ]]; then
    echo "Error: argument must be in dataset@snapshot format (e.g. vault@my-snap)" >&2
    return 2
  fi

  dataset="${spec%@*}"
  snap="${spec#*@}"

  # Find mountpoint for the dataset
  mp="$(zfs get -H -o value mountpoint "$dataset" 2>/dev/null)" || true
  if [[ -z "$mp" || "$mp" == "-" || "$mp" == "legacy" ]]; then
    echo "Error: could not determine a usable mountpoint for dataset '$dataset' (got: '$mp')" >&2
    return 1
  fi

  # Optional second arg: restrict listing to a subpath inside the snapshot
  local subpath="${2:-}"
  local snapdir="$mp/.zfs/snapshot/$snap"

  if [[ ! -d "$snapdir" ]]; then
    echo "Error: snapshot path not found: $snapdir" >&2
    echo "Notes:" >&2
    echo "  - Ensure snapshot exists: zfs list -t snapshot | grep -F \"$spec\"" >&2
    echo "  - Ensure .zfs is visible/accessible on $mp" >&2
    return 1
  fi

  # If a subpath is provided, list only that area
  if [[ -n "$subpath" ]]; then
    snapdir="$snapdir/$subpath"
  fi

  if [[ ! -e "$snapdir" ]]; then
    echo "Error: path inside snapshot not found: $snapdir" >&2
    return 1
  fi

  # List recursively; print relative paths (cleaner)
  ( builtin cd "$snapdir" && find . -mindepth 1 -print | sed 's#^\./##' )
}
