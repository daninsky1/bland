#!/bin/sh
# yt-dlp manager for Ubuntu: always installs/updates to latest Linux release binary

YTDLP_BIN="/usr/local/bin/yt-dlp"

install() {
    if command -v curl >/dev/null 2>&1; then
        sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$YTDLP_BIN"
    else
        echo "Error: Install curl or wget (sudo apt install curl)"
        exit 1
    fi
    sudo chmod a+rx "$YTDLP_BIN"
    echo "Installed latest yt-dlp to $YTDLP_BIN"
    yt-dlp --version
}

uninstall() {
    if [ -f "$YTDLP_BIN" ]; then
        sudo rm -f "$YTDLP_BIN"
        echo "Removed yt-dlp from $YTDLP_BIN"
    fi
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
