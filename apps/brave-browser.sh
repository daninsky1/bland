#!/bin/sh

install() {
    if [ ! -f /etc/apt/sources.list.d/brave-browser-release.list ]; then
        [ -f /usr/share/keyrings/brave-browser-archive-keyring.gpg ] && sudo rm /usr/share/keyrings/brave-browser-archive-keyring.gpg
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    fi

    sudo apt update
    sudo apt install -y brave-browser
}

uninstall() {
    sudo apt remove -y brave-browser
    sudo rm /etc/apt/sources.list.d/brave-browser-release.list
    sudo rm /usr/share/keyrings/brave-browser-*.gpg
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
