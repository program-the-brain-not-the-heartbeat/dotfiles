pools() {
    local ver="${1:-$(ls /etc/php | sort -V | tail -n1)}"
    cd "/etc/php/$ver/fpm/pool.d/" || echo "Version $ver not installed currently on this system."
}
phplint() {
    find . -type f -name "*.php" -print0 | xargs -0 -n1 php -l
}
alias php_limits='php -i | egrep "memory_limit|upload_max_filesize|post_max_size"'
alias php_fatals='sudo grep -i "PHP Fatal error" /var/log/nginx/error.log | tail'


# Search all /home/**/private/account.json for a specific PHP version
php_accounts_by_version() {
    local wanted_version="$1"

    if [[ -z "$wanted_version" ]]; then
        echo "Usage: php_accounts_by_version <php_version>"
        echo "Example: php_accounts_by_version 8.3"
        return 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "Error: 'jq' is required but not installed." >&2
        return 1
    fi

    # Find all account.json files and iterate over them
    find /home -type f -path '*/private/account.json' -print0 2>/dev/null | \
    while IFS= read -r -d '' file; do
        # Get the PHP version from the JSON (if present)
        local php_version
        php_version=$(jq -r '.infrastructure.php.version // empty' "$file" 2>/dev/null) || continue

        # Skip if no version or doesn't match requested version
        [[ -z "$php_version" ]] && continue
        [[ "$php_version" != "$wanted_version" ]] && continue

        # Grab a few useful fields for context
        local shell_user domain db_name
        shell_user=$(jq -r '.shell.user // empty' "$file")
        domain=$(jq -r '.domains[0].domain // empty' "$file")
        db_name=$(jq -r '.database.name // empty' "$file")

        printf 'MATCH: %s\n' "$file"
        printf '  php_version : %s\n' "$php_version"
        printf '  shell_user  : %s\n' "$shell_user"
        printf '  domain      : %s\n' "$domain"
        printf '  database    : %s\n' "$db_name"
        echo
    done
}


update_php_version_in_accounts() {
    local new_version="$1"

    if [[ -z "$new_version" ]]; then
        echo "Usage: update_php_version_in_accounts <php_version>"
        echo "Example: update_php_version_in_accounts 8.3"
        return 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "Error: jq is required."
        return 1
    fi

    # Sockets look like: /run/php/php8.3-novastream.sock
    # We only scan real sockets (-type s), so php-fpm.sock (symlink) is ignored.
    mapfile -t sockets < <(
        find /run/php \
            -maxdepth 1 \
            -type s \
            -name "php${new_version}-*.sock" 2>/dev/null
    )

    if (( ${#sockets[@]} == 0 )); then
        echo "No sockets found for PHP version: ${new_version}"
        return 0
    fi

    for sock in "${sockets[@]}"; do
        local sock_base home_name account_json tmp_file

        sock_base=$(basename "$sock")

        # Explicitly ignore master FPM pool sockets like php8.4-fpm.sock
        if [[ "$sock_base" == "php${new_version}-fpm.sock" ]]; then
            # echo "Skipping master pool socket: $sock_base"
            continue
        fi

        # php8.3-novastream.sock → novastream
        home_name="${sock_base#php${new_version}-}"
        home_name="${home_name%.sock}"

        account_json="/home/${home_name}/private/account.json"

        if [[ ! -f "$account_json" ]]; then
            # If there's no account.json for this "home", just skip.
            # This also protects us if some odd socket name sneaks in.
            # echo "Missing account.json for ${home_name}, skipping."
            continue
        fi

        echo "Updating PHP version for ${home_name} → ${new_version}"
        echo "  socket: $sock"
        echo "  file  : $account_json"

        # Drop immutable flag (ignore errors if not set)
        chattr -i "$account_json" 2>/dev/null || true

        tmp_file="$(mktemp)"
        if jq --arg v "$new_version" \
              '.infrastructure.php.version = $v' \
              "$account_json" > "$tmp_file"; then
            mv "$tmp_file" "$account_json"
        else
            echo "  ✖ Failed to update JSON for ${home_name}"
            rm -f "$tmp_file"
            continue
        fi

        # Restore immutable flag
        chattr +i "$account_json" 2>/dev/null || true

        echo "  ✔ Updated"
        echo
    done
}
