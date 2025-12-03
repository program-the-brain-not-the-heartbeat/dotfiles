
case ":$PATH:" in
  *":$LOCAL_BIN:"*) ;;
  *) export PATH="$PATH:$LOCAL_BIN" ;;
esac

export PATH="$HOME/.local/bin:/opt/NovaStream/scripts/shared:$PATH"
