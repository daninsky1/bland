#!/bin/sh

if [ $# -ne 3 ]; then
    echo "Usage: $0 <schema> <key> <keybindings-array>"
    echo "Example: $0 org.gnome.desktop.wm.keybindings switch-applications \"['<Alt>F2','<Control>F2']\""
    exit 1
fi

SCHEMA="$1"
KEY="$2"
KEY_ARRAY="$3"

# Caches the gsettings queries
CACHE=$(mktemp)
trap 'rm -f "$CACHE"' EXIT
for schema in $(gsettings list-schemas); do
    for key in $(gsettings list-keys "$schema"); do
        val=$(gsettings get "$schema" "$key")
        printf '%s %s %s\n' "$schema" "$key" "$val" >> "$CACHE"
    done
done

# Search for duplicated keybindings
KEYS=$(echo "$KEY_ARRAY" | tr -d "[] " | tr ',' '\n')
CONFLICTS=""
for k in $KEYS; do
    DUPLICATE=$(grep "$k" "$CACHE" | grep -v "^$SCHEMA $KEY ")
    if [ -n "$DUPLICATE" ]; then
        CONFLICTS="$CONFLICTS$k:\n$DUPLICATE\n\n"
    fi
done

# Print conflicts (if any)
# if [ -n "$CONFLICTS" ]; then
#     echo "Some keybindings are already in use:"
#     printf '%b' "$CONFLICTS"
#     exit 1
# fi

if [ -n "$CONFLICTS" ]; then
    echo "Some keybindings are already in use:"
    for k in $KEYS; do
        grep --color=always "$k" "$CACHE" | grep -v "^$SCHEMA $KEY "
        echo
    done
    exit 1
fi

# Safely set keybidings
gsettings set "$SCHEMA" "$KEY" "$KEY_ARRAY"
echo "Keybinding $KEY_ARRAY assigned to $SCHEMA -> $KEY successfully."
