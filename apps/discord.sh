#!/bin/sh

install() {
    cd /tmp
    wget -O discord.deb https://discord.com/api/download?platform=linux
    sudo apt install -y ./discord.deb
    rm discord.deb
    cd -
}

uninstall() {
    sudo apt remove -y discord
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