#!/bin/bash

# https://youtu.be/eiDt4O6UPRw?si=vy07KR-tHoF8436f

# the best practice to use fish as default is to run in interactive mode
# .bashrc: 'fish -i', but this makes you need to exit two shell layers to
# get out, so you need to run this:
# "distrobox enter ubuntubox -- bash -lc 'exec fish'"

# distrobox-host-exec bug
# https://github.com/89luca89/distrobox/issues/1198
# needs flatpak to fix

# distrobox-host-exec to open vscode on host and open browser to login on
# github and sync

# Select container preferably podman
# echo 'container_manager="podman"' > ~/.config/distrobox/distrobox.conf

install() {
    wget -qO- https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
    sudo apt install -y podman crun flatpak
}

uninstall() {
    wget -qO- https://raw.githubusercontent.com/89luca89/distrobox/main/uninstall | sudo sh
    sudo apt remove -y podman
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