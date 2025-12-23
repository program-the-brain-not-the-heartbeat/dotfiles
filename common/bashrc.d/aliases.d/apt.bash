function update() {
    sudo apt-get -qq update && sudo apt-get -qq upgrade -y
    if [ $? -eq 0 ]; then
        echo "System update and upgrade completed successfully."
    else
        echo "There was an error during the update or upgrade process." >&2
        return 1
    fi

    if [ -f /var/run/reboot-required ]; then
        echo "A system reboot is required."
    fi
}
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"
