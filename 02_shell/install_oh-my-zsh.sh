#!/bin/bash
source ../common/aliases.sh
source ../common/install.sh

if [ "$(is_ubuntu)" -eq 1 ]; then
	install_programs zsh
	install_programs gawk
else
	install_programs zsh zsh-completions
fi
install_programs curl

if [[ -z $ZSH ]]; then
	sudo chsh -s "$(which zsh)" # Change default shell for root user
	chsh -s "$(which zsh)"      # Change default shell for normal user

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	iconpath='.local/share/icons/hicolor/64x64/actions'
	mkdir -p "$HOME/$iconpath"
	cp {success,fail}.png "$HOME/$iconpath"

	if ! grep -sq "bgnotify_formatted" "$HOME"/.zshrc ; then
		plugins="git bgnotify sudo"
		# Use the bgnotify custom command from the bgnotify readme, but modify it
		bgnotify_func=$(awk 'BEGIN{In_function = 0}{if ($0 == "function bgnotify_formatted {") In_function = 1; if (In_function) print $0; if ($0 == "}") In_function = 0}' "$HOME"/.oh-my-zsh/plugins/bgnotify/README.md | sed "s|Holy Smokes Batman|Great success|; s|Holy Graf Zeppelin|Command failed|; s|\$HOME/icons|\$HOME/$iconpath|g")

		awk -v plugins="$plugins" -v bgnotify_func="${bgnotify_func}" -i inplace '{if ($0 ~ /^plugins=(.*)$/) print bgnotify_func "\nplugins=(" plugins ")"; else print $0}' "$HOME"/.zshrc
	fi

	if ! command -v eza >/dev/null 2>&1 ; then
		make_alias "alias l='ls  -la --group-directories-first'"
		make_alias "alias ll='ls -la --group-directories-first'"
	else
		make_alias "alias l='eza  -la --icons=always --time-style=long-iso --git --git-repos'"
		make_alias "alias ll='eza -la --icons=always --time-style=long-iso --git --git-repos'"
	fi
	make_alias "alias weather='curl wttr.in\?M'"
	make_alias "alias distory='vim $HOME/.zsh_history'"
	make_alias "alias dedup='find . ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD'"
fi
