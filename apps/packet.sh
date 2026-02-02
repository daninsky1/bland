#!/bin/bash

install() {
    flatpak install flathub -y io.github.nozwock.Packet
}

uninstall() {
    flatpak uninstall flathub -y io.github.nozwock.Packet
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