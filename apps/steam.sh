#!/bin/sh

install() {
    cd /tmp
    wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
    sudo apt install -y ./steam.deb
    rm steam.deb
    cd -
}

uninstall() {
    sudo apt remove -y steam steam-launcher
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
