alias sites='cd /etc/nginx/sites-enabled'
alias sitesa='cd /etc/nginx/sites-available'
alias snippets='cd /etc/nginx/snippets'
alias toggle-site='toggle-nginx-site'
nginx-logs() {
    cd /var/log/nginx/ || echo "nginx logs not found"
}

# Test config and reload
reload-nginx() {
    sudo nginx -t && sudo systemctl reload nginx
}
