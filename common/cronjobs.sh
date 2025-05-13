#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR"/install.sh

add_cronjob_to_check_git_repository() {
	local DIR="$1"
	local COMPONENT="${2:-$(basename "$DIR")}"

	install_programs cronie
	sudo systemctl enable cronie.service
	sudo systemctl start  cronie.service

	mkdir  -p "$HOME"/bin
	if [ ! -f "$HOME"/bin/check_git_for_updates.sh ]; then
		cp "$SCRIPT_DIR"/check_git_for_updates.sh "$HOME"/bin/check_git_for_updates.sh
	fi

	mkdir  -p "$HOME"/.letters
	mkdir  -p "$HOME"/bin/letters
	if [ ! -f "$HOME"/bin/letters/empty_letterbox.sh ]; then
		cp  "$SCRIPT_DIR"/letters/empty_letterbox.sh "$HOME"/bin/letters/empty_letterbox.sh
	fi
	if [ ! -f "$HOME"/bin/letters/post_letter.sh ]; then
		cp  "$SCRIPT_DIR"/letters/post_letter.sh "$HOME"/bin/letters/post_letter.sh
	fi
	if ! grep -sq "source \$HOME/bin/letters/empty_letterbox.sh" "$HOME"/.bashrc ; then
		echo "source \$HOME/bin/letters/empty_letterbox.sh"  >>  "$HOME"/.bashrc
	fi
	if ! grep -sq "source \$HOME/bin/letters/empty_letterbox.sh" "$HOME"/.zshrc ; then
		echo "source \$HOME/bin/letters/empty_letterbox.sh"  >>  "$HOME"/.zshrc
	fi

	(crontab -l 2>/dev/null; echo "0 */2 * * * $HOME/bin/check_git_for_updates.sh $DIR $COMPONENT") | crontab -
}
