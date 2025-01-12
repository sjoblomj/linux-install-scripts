#!/bin/bash
source ../common/cronjobs.sh

post_wayland_letter() {
    local filename="$HOME/.letters/wayland"
    local curr_dir=$(pwd)
    mkdir -p $HOME/.letters

    NO_FORMAT="\033[0m"
    F_BOLD="\033[1m"
    F_UNDERLINE="\033[4m"
    C_GREY46="\033[38;5;243m"
    C_WHITE="\033[38;5;15m"
    echo -e "${F_BOLD}${F_UNDERLINED}${C_WHITE}Wayland session${NO_FORMAT}" > "$filename"
    echo -e "${C_WHITE}Make sure you use a Wayland session. On the login screen, press the 'Settings gear' in the bottom right corner and select 'Ubuntu on Wayland'. When running a Wayland session, the following command should not be empty:${NO_FORMAT}" >> "$filename"
    echo -e "${C_GREY46}echo \$WAYLAND_DISPLAY${NO_FORMAT}" >>   "$filename"
}
if [[ -z "$WAYLAND_DISPLAY" ]]; then
    post_wayland_letter
fi

# Make Super+Enter open terminal:
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>Return"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "x-terminal-emulator"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"

# Disable window preview on Alt+Tab
gsettings set org.gnome.shell.window-switcher app-icon-mode 'app-icon-only'
