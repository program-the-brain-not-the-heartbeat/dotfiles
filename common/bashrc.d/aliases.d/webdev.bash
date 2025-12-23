
lighthouse_clean() {
  local domain="$1"
  local report_file="${2:-report.html}"
  local hosts_file="/etc/hosts"
  local temp_file="/tmp/hosts.modified.$(date +%s)"

  export CHROME_PATH="/usr/bin/google-chrome"

  if [[ -z "$domain" ]]; then
    echo "Usage: lighthouse_clean <domain> [output_file.html]"
    return 1
  fi

  echo "[>] Temporarily disabling $domain and www.$domain in $hosts_file"
  sudo sed "/[[:space:]]$domain$/s/^/#TEMP#/" "$hosts_file" | \
  sudo sed "/[[:space:]]www\.$domain$/s/^/#TEMP#/" | \
  sudo tee "$temp_file" > /dev/null

  sudo cp "$temp_file" "$hosts_file"
  rm -f "$temp_file"

  echo "[>] Running Lighthouse audit on https://$domain"
  lighthouse "https://$domain" \
    --output html \
    --output-path "$report_file" \
    --chrome-flags="--no-sandbox --headless --disable-gpu --disable-dev-shm-usage  --ignore-certificate-errors"

  echo "[>] Re-enabling $domain and www.$domain in $hosts_file"
  sudo sed -i "/^#TEMP#/s/^#TEMP#//" "$hosts_file"

  echo "[✓] Done. Report saved to: $report_file"
}


function screamingfrogseospider() {
    /usr/bin/screamingfrogseospider "$@" --headless
}

alias wget-site='wget --mirror -p --convert-links -P'
alias mirror='wget --r --no-parent --no-clobber -e robots=off -R "index.html*" '
og() { curl -s "https://opengraph.io/api/1.1/site/$1" | jq .; }
unshorten() {
    curl -ILs "$1" | grep -i "^location:"
}
