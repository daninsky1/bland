install() {
    cd /tmp
    wget -O nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
    tar -xf nvim.tar.gz
    sudo install nvim-linux-x86_64/bin/nvim "${HOME}/.local/bin/nvim"
    sudo cp -R nvim-linux-x86_64/lib "${HOME}/.local/"
    sudo cp -R nvim-linux-x86_64/share "${HOME}/.local/"
    rm -rf nvim-linux-x86_64 nvim.tar.gz
    cd -

    # Provides a system clipboard interface for Neovim under Wayland
    sudo apt install -y wl-clipboard
}

uninstall() {
    sudo rm ${HOME}/.local/bin/nvim
    sudo rm -r ${HOME}/.local/share/nvim/
    sudo rm -rf ${HOME}/.share/applications/nvim.desktop
    sudo rm -rf ${HOME}/.local/share/applications/nvim.desktop
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
    sudo apt remove -y wl-clipboard
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