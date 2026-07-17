#!/bin/sh

install() {
    sudo apt install -y wget apt-transport-https
    sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
    sudo apt update
    sudo apt install -y element-desktop
}

uninstall() {
    sudo apt remove --purge -y element-desktop
    sudo apt autoremove -y
    sudo rm -f /etc/apt/sources.list.d/element-io.list
    sudo rm -f /usr/share/keyrings/element-io-archive-keyring.gpg
    sudo apt update
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
