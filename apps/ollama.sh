#!/bin/sh

# https://docs.ollama.com/linux

install() {
    curl -fsSL https://ollama.com/install.sh | sh
}

uninstall() {
    sudo systemctl stop ollama
    sudo systemctl disable ollama
    sudo rm -f /etc/systemd/system/ollama.service

    OLLAMA_BIN=$(command -v ollama)
    if [ -n "$OLLAMA_BIN" ]; then
        sudo rm -f "$OLLAMA_BIN"
    fi

    # Remove the downloaded models and Ollama service user and group.
    sudo userdel ollama
    sudo groupdel ollama
    sudo rm -rf /usr/share/ollama
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
