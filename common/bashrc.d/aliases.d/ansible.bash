# These were slopped by ChatGPT. Untested.

playbook() {
    local base_dir="/opt/mutexlabs/ansible/playbooks"
    local root_dir="/opt/mutexlabs/ansible"

    # capture and remove the playbook argument from the arg list
    local play="${1-}"
    shift || true

    if [[ -z "$play" ]]; then
        echo "Usage: playbook <playbook.yml|playbook.yaml> [ansible-playbook args]" >&2
        return 2
    fi

    # enforce filename-only to avoid ambiguity
    if [[ "$play" == /* || "$play" == *".."* || "$play" == *"/"* ]]; then
        echo "Error: provide only a playbook filename (no paths). Example: playbook site.yml" >&2
        return 2
    fi

    if [[ ! "$play" =~ \.ya?ml$ ]]; then
        echo "Error: playbook must end in .yml or .yaml (got: $play)" >&2
        return 2
    fi

    local path="${base_dir}/${play}"

    if [[ ! -f "$path" ]]; then
        echo "Error: playbook not found: $path" >&2
        return 4
    fi

    export ANSIBLE_CONFIG="${root_dir}/ansible.cfg"
    export ANSIBLE_ROLES_PATH="${root_dir}/roles:/etc/ansible/roles:/usr/share/ansible/roles"

    local ap
    ap="$(command -v ansible-playbook)" || { echo "ansible-playbook not found" >&2; return 127; }
    "$ap" "$path" "$@"
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
