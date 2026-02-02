#!/bin/sh

install() {
    sudo apt install -y fish fonts-powerline || return 1

    fish -c '
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | \
        source && fisher install jorgebucaran/fisher
        fisher install jhillyerd/plugin-git
        fisher install hauleth/agnoster
        agnoster powerline
    '
}

uninstall() {
    sudo apt remove -y fish fonts-powerline
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
