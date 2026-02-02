#!/bin/sh

BOLD=$(tput bold)
RED=$(tput setaf 1)
NC=$(tput sgr0)

if [ -z "$1" ]; then
    echo "Usage: $0 <keybindings-array>"
    echo "Example: $0 \"['<Super>1','<Super>2']\""
    echo
    echo "This script searches whether the specified GNOME keybindings are already in use"
    echo "by any schema/key on the system. It will list all matching keybindings found."
    echo "This helps you identify which keybindings are in use before assigning new ones."
    exit 1
fi

KEY_ARRAY="a$1"

# Caches the gsettings queries
CACHE=$(mktemp)
trap 'rm -f "$CACHE"' EXIT
for schema in $(gsettings list-schemas); do
    for key in $(gsettings list-keys "$schema"); do
        val=$(gsettings get "$schema" "$key")
        printf '%s %s %s\n' "$schema" "$key" "$val" >> "$CACHE"
    done
done

# Search for keybindings usage
KEYS=$(echo "$KEY_ARRAY" | tr -d "[] " | tr ',' '\n')
USAGES=""
for k in $KEYS; do
    USAGE=$(grep --color=always "$k" "$CACHE")
    if [ -n "$USAGE" ]; then
        USAGES="$USAGES${BOLD}${RED}$k${NC}:\n$USAGE\n\n"
    fi
done

# Print usages if any
if [ -n "$USAGES" ]; then
    echo "Some keybindings are already in use:"
    printf '%b' "$USAGES"
    exit 1
else
    echo "None of the specified keybindings are in use."
fi
