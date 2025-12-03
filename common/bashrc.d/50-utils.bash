if command -v batcat >/dev/null 2>&1; then
    # Default pager: batcat (plain style, always page)
    # This will affect tools that honor $PAGER (git, etc.)
    export PAGER="batcat --decorations=always --color=always"

    # Systemd tools (journalctl, systemctl, etc.)
    # They use SYSTEMD_PAGER first; point it to batcat as well.
    export SYSTEMD_PAGER="$PAGER"

    # Man pages through batcat
    # col -bx strips backspaces and formatting, -l man for syntax
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

    # Optional: how batcat itself pages *its* output
    # (batcat pipes into BAT_PAGER, default is less)
    export BAT_PAGER="less -FR"
fi
