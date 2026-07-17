#!/bin/sh

DOWNLOAD_PAGE_URL="https://www.pcloud.com/how-to-install-pcloud-drive-linux.html?download=electron-64"
BIN_DIR="${HOME}/opt/pcloud"
BIN_PATH="${BIN_DIR}/pcloud"
PROVIDER_SHA256SUM=

install() {
    # depends on jq, curl, grep, awk

    # Parse page to get public download link code and download hash
    DOWNLOAD_PAGE_RESPONSE="$(curl -sfL "$DOWNLOAD_PAGE_URL")"
    DOWNLOAD_METADATA="$(echo "$DOWNLOAD_PAGE_RESPONSE" | \
        grep "'Electron'" | \
        awk -F"'" '{ print $4 }')"
    # printf to mitigate inconsistency echo \n handling
    GET_PUB_LINK_CODE="$(printf '%s\n' "$DOWNLOAD_METADATA" | head -n1)"
    PROVIDER_SHA256SUM="$(printf '%s\n' "$DOWNLOAD_METADATA" | tail -n1)"
    [ -n "$GET_PUB_LINK_CODE" ] || { echo "No publink code"; exit 1; }
    [ -n "$PROVIDER_SHA256SUM" ] || { echo "No SHA256"; exit 1; }

    # parse download url
    GET_PUB_LINK_URL="https://api.pcloud.com/getpublinkdownload?code=$GET_PUB_LINK_CODE"
    GET_PUB_LINK_RESPONSE="$(curl -sfL "$GET_PUB_LINK_URL")"
    PCLOUD_HOST="$(printf '%s\n' "$GET_PUB_LINK_RESPONSE" | jq -r '.hosts[0]')"
    PCLOUD_PATH_API="$(printf '%s\n' "$GET_PUB_LINK_RESPONSE" | jq -r '.path')"

    [ -n "$PCLOUD_HOST" ] || { echo "No host"; exit 1; }
    [ -n "$PCLOUD_PATH_API" ] || { echo "No path"; exit 1; }

    DOWNLOAD_URL="https://$PCLOUD_HOST$PCLOUD_PATH_API"

    # Kill any running instance of pCloud from a previous installation
    killall pcloud 2>/dev/null || true

    # Wait until process fully exits
    while pgrep -x pcloud >/dev/null; do
        sleep 0.1
    done

    sudo apt install -y libfuse2t64
    mkdir -p "$BIN_DIR"

    # Download
    curl -fL --progress-bar -o "$BIN_PATH" "$DOWNLOAD_URL" || {
        echo "Download failed"
        exit 1
    }

    check_hash "$PROVIDER_SHA256SUM"

    # Running the AppImage for the first time automatically creates
    # a .desktop entry and a user systemd startup entry.
    chmod +x "$BIN_PATH"
    nohup "$BIN_PATH" > /dev/null 2>&1 &

    printf "\npCloud installed and running."
}

uninstall() {
    # Use 'apt autoremove' to remove libfuse2t64 if no other package depends
    # on it
    # when the pcloud AppImage binary is deleted magically the autostart from
    # systemd and .desktop are removed, they have a vigilant watching somehow
    rm -r "$BIN_DIR"
    printf "\npCloud removed."
}

check_hash() {
    expected_sha256sum="$1"

    echo "Verifying SHA256…"
    if [ -z "$expected_sha256sum" ]; then
        echo "Failed to extract SHA256 from pCloud page"
        exit 1
    fi

    # Looks like sha256sum expect stdin in this format <hash><two spaces><file>
    # I don't know why, maybe a Unix command chaining thing
    if ! echo "$expected_sha256sum  $BIN_PATH" | sha256sum -c -; then
        echo "$expected_sha256sum"
        sha256sum "$BIN_PATH"
        rm -f "$BIN_PATH"
        exit 1
    fi

    echo "hash: $expected_sha256sum, $BIN_PATH"
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
