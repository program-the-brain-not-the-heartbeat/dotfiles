function sr {
    wp cache flush || true
    wp transient delete --all

    if [[ ! -z $1 && ! -z $2 ]]; then
        wp search-replace $1 $2 --recurse-objects --all-tables --precise --allow-root
    fi

    if wp plugin is-installed elementor --quiet --allow-root && wp plugin is-active elementor --quiet --allow-root; then
        wp elementor flush_css --allow-root
    fi
}


function sre {
    wp cache flush || true
    wp transient delete --all

    if wp plugin is-installed elementor --quiet --allow-root && wp plugin is-active elementor --quiet --allow-root; then
        wp elementor flush_css --allow-root
    fi

    if [[ ! -z $1 && ! -z $2 ]]; then
        wp search-replace $1 $2 --skip-columns=guid --recurse-objects --precise --all-tables --allow-root --skip-plugins --skip-themes --export=db.sql
    fi
}


function theme {
  # TODO: Make this use /var/www or /home based on setup
  if [[ -z $1 ]]; then
     cd /home
  else
     if [[ -d /var/www/$1/public/wp-content ]]; then
         THEME_DIR=$(ls -d /home/$1/public/wp-content/themes/!(twenty*)|head -n 1) 2>/dev/null
    #     echo $THEME_DIR
         if [[ -d $THEME_DIR ]]; then
            cd $THEME_DIR
            npx browserslist@latest --update-db
            if [[ -f "$THEME_DIR/gulpfile.js" ]]; then
                gulp
            fi
         else
            cd /home/$1/public/wp-content/themes/
         fi
     else
         cd /home/$1
     fi
  fi
}

function wp() {
    /usr/local/bin/wp "$@" --allow-root
}

function wordfence() {
    /usr/bin/wordfence "$@" --no-banner --no-color
}

alias malwarescan='wordfence malware-scan --overwrite --output-format=csv --output-headers --output-path /root/wordfence-home.csv --match-engine=vectorscan /home'
alias malwarescan2='wordfence malware-scan --overwrite --output-format=csv --output-headers --output-path /root/wordfence-home.csv --match-engine=pcre /home'
alias recent-malware-scan='find /home -cmin -720 -type f -print0 | wordfence malware-scan'
alias vulnscan='wordfence vuln-scan --output-format=csv --output-headers --output-columns=scanned_path,software_type,slug,version,id,title,link,description,cve,cvss_vector,cvss_score,cvss_rating,cwe_id,cwe_name,cwe_description,patched,remediation,published,updated  --output-path=/root/wordfence-vuln-home.csv /home'
alias disable-wordpress-debugging='bash -c '\''for const in WP_DEBUG WP_DEBUG_DISPLAY WP_DEBUG_LOG SAVEQUERIES SCRIPT_DEBUG; do wp @all config delete "$const" --type=constant || true; wp @all config set "$const" false --raw --type=constant; done'\'''


alias check-wordpress-admin-email='wp @all eval-file - < /usr/local/libexec/wordpress-check-admin-email.php 2>/dev/null'
alias check-wordpress-forms-email='wp @all eval-file - < /usr/local/libexec/wordpress-check-forms.php 2>/dev/null'
alias check-wordpress-template='wp @all eval-file - < /usr/local/libexec/wordpress-check-template-string.php 2>/dev/null'
alias check-wordpress-plugin='wp @all eval-file - < /usr/local/libexec/wordpress-check-plugin.php $1 2>/dev/null'
alias disable-wordpress-debugging='bash -c '\''for const in WP_DEBUG WP_DEBUG_DISPLAY WP_DEBUG_LOG SAVEQUERIES SCRIPT_DEBUG; do wp @all config delete "$const" --type=constant || true; wp @all config set "$const" false --raw --type=constant; done'\'
