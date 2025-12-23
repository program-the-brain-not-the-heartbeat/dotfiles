alias iplan='ip -4 addr show'
alias ipwan='curl -s ifconfig.me'
alias wanip='ipwan'
alias myip='curl -s ifconfig.me'
alias extip='curl icanhazip.com'
alias pingg='ping google.com'


alias flush-dns='sudo systemd-resolve --flush-cache && sudo systemd-resolve --statistics'
alias digg='dig +short'
alias ip='ip -c '
alias ports='sudo lsof -i -P -n'                 # what’s using ports
alias whichport='sudo lsof -i -P -n | grep'
alias nodeports='sudo lsof -i -P -n | grep node'
alias port-pid='f() { sudo lsof -nP -iTCP:$1 -sTCP:LISTEN 2>/dev/null || echo "No process is listening on port $1"; }; f'
alias ports-all='echo "--- netstat ---"; ports-netstat; echo "--- ss ---"; ports-ss; echo "--- lsof ---"; ports-lsof'
alias ports-lsof='sudo lsof -i -P -n | grep LISTEN'
alias ports-lsof-full='sudo lsof -nP -iTCP -sTCP:LISTEN'
alias ports-netstat='sudo netstat -tuln | grep LISTEN'
alias ports-ss='ss -tuln'
alias ports-ss-full='sudo ss -tulnp'
alias listen='sudo ss -tulnp'                    # services listening
alias hosts='sudo nano /etc/hosts'
alias proc-ports='f() {
  input="$1"
  if [[ -z "$input" ]]; then echo "Usage: proc-ports <process name or PID>"; return; fi

  if [[ "$input" =~ ^[0-9]+$ ]]; then
    pids="$input"
  else
    pids=$(pgrep -fi "$input")
  fi

  if [[ -z "$pids" ]]; then
    echo "No matching process found for \"$input\""
    return
  fi

  for pid in $pids; do
    if ! ps -p "$pid" > /dev/null 2>&1; then
      continue
    fi
    name=$(ps -p "$pid" -o comm=)
    output=$(sudo lsof -nP -iTCP -sTCP:LISTEN -a -p "$pid" 2>/dev/null)
    if [[ -n "$output" ]]; then
      echo "→ Listening ports for PID $pid ($name):"
      echo "$output"
    fi
  done

  if [[ -z "$output" ]]; then
    echo "No listening ports found for \"$input\""
  fi
}; f'

ipinfo() {
    # Decide target: $1 or wanip()
    if [ -z "$1" ]; then
        target="$(wanip)"
    else
        target="$1"
    fi

    # If it's not a bare IPv4, try to resolve it as a domain
    if ! printf '%s\n' "$target" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
        ip=$(dig +short "$target" | head -n 1)
        if [ -z "$ip" ]; then
            echo "Unable to resolve domain: $target" >&2
            return 2
        fi
    else
        ip="$target"
    fi

    # Query ipwho.is and pretty print JSON
    curl -s "https://ipwho.is/$ip" | jq .
}

countryinfo() {
    curl -s "https://restcountries.com/v3.1/name/$1" | jq .
}
