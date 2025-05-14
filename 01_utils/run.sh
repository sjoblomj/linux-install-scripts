#!/bin/bash
source ../common/aliases.sh
source ../common/install.sh
source ../common/menu.sh

confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
datadir="${XDG_DATA_HOME:-$HOME/.local/share}"

preview_dir="programs/"
title="Choose programs to install (Select with Tab)"
selections=$(find "$preview_dir" -type f -exec basename {} \; | sort | multi_select_menu "$title" "cat $preview_dir{}")

if [ "$(is_ubuntu)" -eq 1 ]; then
	if [ -n "$selections" ]; then

		if [[ "$selections" =~ "bottom" ]]; then
			install_programs curl
			tempfile=$(mktemp)
			url=$(curl -sL \
			  -H "Accept: application/vnd.github+json" \
			  -H "X-GitHub-Api-Version: 2022-11-28" \
			  "https://api.github.com/repos/ClementTsang/bottom/releases" | \
			  jq -r '[.[] | select(.prerelease == false)][0].assets[] | select((.browser_download_url | contains("amd64.deb")) and (.browser_download_url | contains("musl") | not)) | .browser_download_url')
			curl -L "$url" -o "$tempfile"
			sudo dpkg -i "$tempfile"
			rm "$tempfile"
			selections=${selections/bottom/}
		fi
		if [[ "$selections" =~ "dust" ]]; then
			sudo snap install dust
			selections=${selections/dust/}
		fi
		if [[ "$selections" =~ "gtop" ]]; then
			install_programs npm
			sudo npm install gtop -g
			selections=${selections/gtop/}
		fi
		if [[ "$selections" =~ "papers" ]]; then
			flatpak install flathub org.gnome.Papers
			selections=${selections/papers/}
		fi
		if [[ "$selections" =~ "task" ]]; then
			install_programs taskwarrior
			selections=${selections/task/}
		fi
		if [[ "$selections" =~ "bat" ]]; then
			make_alias "alias bat='batcat'"
		fi

		install_programs $selections
	fi

else # Not Ubuntu
	if [ -n "$selections" ]; then
		install_programs $selections
		if [[ "$selections" =~ "vlc" ]]; then
			install_programs qt5-wayland
			mkdir -p "$datadir"/icons/hicolor/scalable/apps
			curl https://upload.wikimedia.org/wikipedia/commons/e/e6/VLC_Icon.svg -o "$datadir"/icons/hicolor/scalable/apps/vlc.svg
		fi
		if [[ "$selections" =~ "lximage-qt" ]]; then
			install_programs qt6-wayland qt6-imageformats kimageformats
			install_programs deepin-icon-theme
			mkdir  -p "$confdir"/lximage-qt
			if [ ! -f "$confdir"/lximage-qt/settings.conf ]; then
				echo "[General]" >> "$confdir"/lximage-qt/settings.conf
				echo "fallbackIconTheme=vintage" >> "$confdir"/lximage-qt/settings.conf
			fi
			# lximage-qt can handle all image formats supported by Qt as well as images extended by qt6-imageformats and kimageformats.
			# These are supported by Qt: https://doc.qt.io/qt-6/qimagereader.html#supportedImageFormats
			install_programs xdg-utils
			xdg-mime default lximage-qt.desktop image/bmp image/gif image/jpeg image/png image/x-portable-bitmap image/x-portable-graymap image/x-portable-pixmap image/x-xbitmap image/x-xpixmap image/svg+xml
		fi
		if [[ "$selections" =~ "papers" ]]; then
			install_programs xdg-utils
			xdg-mime default org.gnome.Papers.desktop application/pdf
		fi
		if [[ "$selections" =~ "transmission-qt" ]]; then
			install_programs qt6-wayland
			sudo curl https://upload.wikimedia.org/wikipedia/commons/4/46/Transmission_Icon.svg -o /usr/share/icons/hicolor/scalable/apps/transmission.svg
			sudo curl https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Transmission_Icon.svg/48px-Transmission_Icon.svg.png -o /usr/share/icons/hicolor/48x48/apps/transmission.png
			sudo gtk-update-icon-cache /usr/share/icons/hicolor
		fi
	fi
fi
