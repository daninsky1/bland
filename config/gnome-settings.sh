#!/bin/sh

WALLPAPER_URL="https://zebreus.github.io/all-gnome-backgrounds/images/blobs-l-58c6f1448adb4883c18852b570b9d44450a25c69.webp"
BACKGROUND_DEST_DIR="$HOME/.local/share/backgrounds"
BACKGROUND_DEST_PATH="$BACKGROUND_DEST_DIR/blobs.webp"

set_config() {
    # Turn off default Ubuntu extensions
    gnome-extensions disable tiling-assistant@ubuntu.com
    gnome-extensions disable ubuntu-appindicators@ubuntu.com
    gnome-extensions disable ubuntu-dock@ubuntu.com
    gnome-extensions disable ding@rastersoft.com

    # Workspage keybindings
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control><Super>Left']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control><Super>Right']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Control><Super>Up']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Control><Super>Down']"

    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Super><Alt>Left']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Super><Alt>Right']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Alt>Up']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Alt>Down']"

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

    # Window keybindings
    gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
    gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
    
    # Remove keybindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['']"
    gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "['']"
    
    gsettings set org.gnome.shell.keybindings toggle-message-tray "['']"

    # Theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface accent-color "teal" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
    gsettings set org.gnome.desktop.interface gtk-theme "Yaru-prussiangreen-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Yaru-prussiangreen-dark"

    if [ ! -d "$BACKGROUND_DEST_DIR" ]; then mkdir -p "$BACKGROUND_DEST_DIR"; fi

    # 1 Download the wallpaper
    if wget -O "$BACKGROUND_DEST_PATH" "$WALLPAPER_URL"; then
        gsettings set org.gnome.desktop.background picture-uri "$BACKGROUND_DEST_PATH"
        gsettings set org.gnome.desktop.background picture-uri-dark "$BACKGROUND_DEST_PATH"
    else 
        echo "Failed to download wallpaper"
    fi

    gsettings set org.gnome.desktop.background picture-options 'zoom'
}

unset_config() {
    gnome-extensions enable tiling-assistant@ubuntu.com
    gnome-extensions enable ubuntu-appindicators@ubuntu.com
    gnome-extensions enable ubuntu-dock@ubuntu.com
    gnome-extensions enable ding@rastersoft.com

    gsettings reset org.gnome.desktop.wm.keybindings switch-to-workspace-left
    gsettings reset org.gnome.desktop.wm.keybindings switch-to-workspace-right
    gsettings reset org.gnome.desktop.wm.keybindings switch-to-workspace-up
    gsettings reset org.gnome.desktop.wm.keybindings switch-to-workspace-down

    gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-left
    gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-right
    gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-up
    gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-down
    
    gsettings reset org.gnome.desktop.wm.keybindings maximize
    gsettings reset org.gnome.desktop.wm.keybindings unmaximize
    
    gsettings reset org.gnome.settings-daemon.plugins.media-keys terminal
    gsettings reset org.gnome.desktop.wm.keybindings activate-window-menu
    gsettings reset org.gnome.shell.keybindings toggle-message-tray

    gsettings reset org.gnome.desktop.interface color-scheme
    gsettings reset org.gnome.desktop.interface accent-color
    gsettings reset org.gnome.desktop.interface cursor-theme
    gsettings reset org.gnome.desktop.interface gtk-theme
    gsettings reset org.gnome.desktop.interface icon-theme

    rm -f "$BACKGROUND_DEST_PATH"

    gsettings reset org.gnome.desktop.background picture-uri
    gsettings reset org.gnome.desktop.background picture-uri-dark
    gsettings reset org.gnome.desktop.background picture-options
}

usage() {
    echo "Usage: $0 -s | -u"
    echo "  -s  Set $0 configuration"
    echo "  -u  Reset to gsettings to defaults"
    exit 1
}

case "$1" in
    -s)
        set_config
        ;;
    -u)
        unset_config
        ;;
    *)
        usage
        ;;
esac

