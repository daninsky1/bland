#!/bin/sh

PCLOUD_URL="https://def2.pcloud.com/cBZT1Rdz77ZUHXec97ZZZK9e10kZ2ZZaALZkZByolVZGFZwLZMRZyYZfHZTQZjpZE4ZvYZkQZdzZB8ZPLZ0RZ2gJM5ZfFqml2buzdzXiIOtxNKKeknQdqb7/pcloud"
PCLOUD_DIR="${HOME}/opt/pcloud"
PCLOUD_PATH="${PCLOUD_DIR}/pcloud"

install_pcloud() {
    sudo apt install -y libfuse2t64
    mkdir -p "$PCLOUD_DIR"
    # Kill any running instance of pCloud from a previous installation
    killall pcloud 2>/dev/null || true

    # Wait until process fully exits
    while pgrep -x pcloud >/dev/null; do
        sleep 0.1
    done
    
    # Download
    wget --no-verbose --show-progress -O "$PCLOUD_PATH" "$PCLOUD_URL" || {
        echo "Download failed"
        exit 1
    }
    
    # Running the AppImage for the first time automatically creates
    # a .desktop entry and a user systemd startup entry.
    chmod +x "$PCLOUD_PATH"
    nohup "$PCLOUD_PATH" > /dev/null 2>&1 &
    
    printf "\npCloud installed and running."
}

uninstall_pcloud() {
    rm "$PCLOUD_PATH"
    printf "\npCloud removed."
    # Use 'apt autoremove' to remove libfuse2t64 if no other package depends
    # on it
    # when the pcloud AppImage binary is deleted magically the autostart from
    # systemd and .desktop are removed, they have a vigilant watching somehow
}
