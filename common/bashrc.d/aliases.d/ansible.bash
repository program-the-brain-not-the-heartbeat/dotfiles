# These were slopped by ChatGPT. Untested.

playbook() {
    local base_dir="/opt/mutexlabs/ansible/playbooks"
    local file="${1-}"
    local path

    if [[ -z "$file" ]]; then
        echo "Usage: playbook <playbook.yml|playbook.yaml> [ansible-playbook args]" >&2
        echo "Example: playbook site.yml -i inventory/prod.ini --check --diff" >&2
        return 2
    fi

    # Reject path traversal / absolute paths (force relative playbook name)
    if [[ "$file" == /* || "$file" == *".."* || "$file" == *"/"* ]]; then
        echo "Error: provide only a playbook filename (no paths). Example: playbook site.yml" >&2
        return 2
    fi

    if [[ ! "$file" =~ \.ya?ml$ ]]; then
        echo "Error: playbook must end in .yml or .yaml (got: $file)" >&2
        return 2
    fi

    path="${base_dir}/${file}"

    if [[ ! -d "$base_dir" ]]; then
        echo "Error: playbook base directory not found: $base_dir" >&2
        return 3
    fi

    if [[ ! -f "$path" ]]; then
        echo "Error: playbook not found: $path" >&2
        # Helpful hint: show close matches (best effort)
        if command -v ls >/dev/null 2>&1; then
            echo "Available playbooks in $base_dir:" >&2
            ls -1 "$base_dir" 2>/dev/null | grep -E '\.ya?ml$' | sed 's/^/  - /' >&2 || true
        fi
        return 4
    fi

    if [[ ! -r "$path" ]]; then
        echo "Error: playbook is not readable: $path" >&2
        return 4
    fi

    if ! command -v ansible-playbook >/dev/null 2>&1; then
        echo "Error: ansible-playbook not found in PATH. Activate your venv or install Ansible." >&2
        return 127
    fi

    ansible-playbook "$path" "$@"
    local rc=$?

    if (( rc != 0 )); then
        echo "Error: ansible-playbook failed (exit code: $rc)" >&2
    fi

    return "$rc"
}

ainv() {
    ansible-inventory -i "$1" --list
}

alint() {
    ansible-lint
}

asyntax() {
    ansible-playbook "$1" --syntax-check
}

atags() {
    ansible-playbook "$1" --list-tags
}

aretry() {
    ansible-playbook "$1" --start-at-task "$2"
}

ap() {
    if [[ "$*" != *"-i "* && "$*" != *"--inventory"* ]]; then
        echo "Error: inventory (-i) is required" >&2
        return 2
    fi
    ansible-playbook "$@"
}

apcheck() {
    ansible-playbook "$@" --check --diff
}

approd() {
    echo "⚠️  You are about to run against PROD"
    read -r -p "Type 'prod' to continue: " confirm
    [[ "$confirm" == "prod" ]] || return 1
    ansible-playbook "$@"
}

ahosts() {
    ansible-inventory -i "$1" --list \
      | jq -r '..|.hosts? // empty | .[]' | sort -u
}

arole() {
    local name="$1"
    [[ -z "$name" ]] && { echo "Usage: arole <role_name>"; return 2; }
    ansible-galaxy role init "roles/$name"
}

acollection() {
    ansible-galaxy collection init "$1"
}

aping() {
    ansible "$1" -i "$2" -m ping
}

ashell() {
    local hosts="$1"
    local inv="$2"
    shift 2
    ansible "$hosts" -i "$inv" -m shell -a "$*"
}

afacts() {
    ansible "$1" -i "$2" -m setup
}

aview() {
    ansible-vault view "$1"
}

aedit() {
    ansible-vault edit "$1"
}

aencrypt() {
    ansible-vault encrypt "$@"
}

adecrypt() {
    ansible-vault decrypt "$@"
}

ans() {
    ansible-playbook \
        --diff \
        --forks 10 \
        "$@"
}
