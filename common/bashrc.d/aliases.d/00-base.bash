# Detect if running via vscode or in a normal terminal
is_vscode() {
  [[ "${TERM_PROGRAM:-}" == "vscode" || -n "${VSCODE_PID:-}" ]]
}
