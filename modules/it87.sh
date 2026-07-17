#!/bin/sh

# https://github.com/frankcrawford/it87

REPOSITORY="https://github.com/frankcrawford/it87.git"
SOURCE_DIR="/usr/local/src/it87"

check_compatibility() {
    BOARD_VENDOR=$(cat /sys/class/dmi/id/board_vendor)
    BOARD_NAME=$(cat /sys/class/dmi/id/board_name)

    if [ "$BOARD_VENDOR" != "Gigabyte Technology Co., Ltd." ]; then
        echo "Unsupported motherboard: $BOARD_VENDOR $BOARD_NAME"
        return 1
    fi
}

is_installed() {
    dkms status 2>/dev/null | grep -q '^it87/' ||
        { modinfo it87 >/dev/null 2>&1 && [ "$(modinfo -F intree it87)" != "Y" ]; }
}

install() {
    check_compatibility || return 1

    if is_installed; then
        echo "it87 is already installed"
        return
    fi

    if lsmod | grep -q '^it87 '; then
        echo "The in-tree it87 module is loaded; unload it before installing"
        return 1
    fi

    sudo apt install -y git dkms build-essential "linux-headers-$(uname -r)" || return 1

    if [ ! -d "$SOURCE_DIR/.git" ]; then
        sudo git clone --depth 1 "$REPOSITORY" "$SOURCE_DIR" || return 1
    fi

    (cd "$SOURCE_DIR" && sudo ./dkms-install.sh)
}

uninstall() {
    if ! is_installed; then
        echo "it87 is not installed"
        return
    fi

    if [ ! -x "$SOURCE_DIR/dkms-remove.sh" ]; then
        echo "Cannot remove it87: $SOURCE_DIR/dkms-remove.sh not found"
        return 1
    fi

    (cd "$SOURCE_DIR" && sudo ./dkms-remove.sh) && sudo rm -rf "$SOURCE_DIR"
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
