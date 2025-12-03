export COMPOSER_HOME="${COMPOSER_HOME:-$XDG_CONFIG_HOME/composer}"
export COMPOSER_CACHE_DIR="${COMPOSER_CACHE_DIR:-$XDG_CACHE_HOME/composer}"

if [ -d "$COMPOSER_HOME/vendor/bin" ]; then
    case ":$PATH:" in
        *":$COMPOSER_HOME/vendor/bin:"*) ;;
        *) PATH="$COMPOSER_HOME/vendor/bin:$PATH" ;;
    esac
fi
