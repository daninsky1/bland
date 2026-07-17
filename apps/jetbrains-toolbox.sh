#!/bin/sh

install() {
    ARCH=$(uname -m)
    TMP_DIR=$(mktemp -d)

    echo "Fetching latest release metadata..."
    JSON=$(curl -sfL "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release")

    case "$ARCH" in
        x86_64)
            URL=$(printf '%s' "$JSON" | jq -r '.TBA[0].downloads.linux.link')
            ;;
        aarch64)
            URL=$(printf '%s' "$JSON" | jq -r '.TBA[0].downloads.linuxARM64.link')
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    echo "Baixando:"
    echo "$URL"

    if [ -z "$URL" ] || [ "$URL" = "null" ]; then
        echo "Failed to find JetBrains Toolbox download URL"
        exit 1
    fi

    curl -fL "$URL" -o "$TMP_DIR/jetbrains-toolbox.tar.gz"

    mkdir -p "$TMP_DIR/jetbrains-toolbox"
    tar -xzf "$TMP_DIR/jetbrains-toolbox.tar.gz" -C "$TMP_DIR/jetbrains-toolbox"

    TOOLBOX_BIN=$(find "$TMP_DIR" -type f -name jetbrains-toolbox | head -n 1)

    if [ -z "$TOOLBOX_BIN" ]; then
        echo "Failed to find JetBrains Toolbox executable"
        exit 1
    fi

    "$TOOLBOX_BIN" &
}

# TODO(Daniel S.): Remove desktop entry
uninstall() {
    echo "JetBrains Toolbox uninstall is not implemented yet"
    exit 1
}

usage() {
    echo "Usage: $0 -i | -u"
    echo "  -i  Install $0"
    echo "  -u  Uninstall $0"
    exit 1
}

case "$1" in
    -i)
        install
        ;;
    -u)
        uninstall
        ;;
    *)
        usage
        ;;
esac
