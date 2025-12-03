export COMPOSER_HOME="${COMPOSER_HOME:-$XDG_CONFIG_HOME/composer}"

if [ -d "$COMPOSER_HOME/vendor/bin" ]; then
    case ":$PATH:" in
        *":$COMPOSER_HOME/vendor/bin:"*) ;;
        *) PATH="$COMPOSER_HOME/vendor/bin:$PATH" ;;
    esac
fi
