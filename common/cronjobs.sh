#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR"/install.sh

setup_letters_and_cronjobs() {
	install_programs cronie
	sudo systemctl enable cronie.service
	sudo systemctl start  cronie.service

	mkdir  -p "$HOME"/.letters
	mkdir  -p "$HOME"/bin/letters
	if [ ! -f "$HOME"/bin/letters/empty_letterbox.sh ]; then
		cp  "$SCRIPT_DIR"/letters/empty_letterbox.sh "$HOME"/bin/letters/empty_letterbox.sh
	fi
	if [ ! -f "$HOME"/bin/letters/post_letter.sh ]; then
		cp  "$SCRIPT_DIR"/letters/post_letter.sh "$HOME"/bin/letters/post_letter.sh
	fi
	if ! grep -sq "source \$HOME/bin/letters/empty_letterbox.sh" "$HOME"/.bashrc ; then
		echo "source \$HOME/bin/letters/empty_letterbox.sh" >> "$HOME"/.bashrc
	fi
	if ! grep -sq "source \$HOME/bin/letters/empty_letterbox.sh" "$HOME"/.zshrc ; then
		echo "source \$HOME/bin/letters/empty_letterbox.sh" >> "$HOME"/.zshrc
	fi
}

add_cronjob_to_check_git_repository() {
	local DIR="$1"
	local COMPONENT="${2:-$(basename "$DIR")}"

	setup_letters_and_cronjobs

	mkdir  -p "$HOME"/bin
	if [ ! -f "$HOME"/bin/check_git_for_updates.sh ]; then
		cp "$SCRIPT_DIR"/check_git_for_updates.sh "$HOME"/bin/check_git_for_updates.sh
	fi

	(crontab -l 2>/dev/null; echo "0 */2 * * * $HOME/bin/check_git_for_updates.sh $DIR $COMPONENT") | crontab -
}

add_cronjob_to_check_git_releases() {
	local COMPONENT="$1"
	local GITHUBREPO="$2"
	local TARGETDIR="$3"
	local VERSION_CMD="$4"

	setup_letters_and_cronjobs

	if [ ! -f "$HOME"/bin/check_github_releases_for_updates.sh ]; then
		cp "$SCRIPT_DIR"/github.sh "$HOME"/bin/check_github_releases_for_updates.sh
		echo "check_for_update \"\$1\" \"\$2\" \"\$3\" \"\$4\"" >> "$HOME"/bin/check_github_releases_for_updates.sh
	fi

	(crontab -l 2>/dev/null; echo "0 */2 * * * $HOME/bin/check_github_releases_for_updates.sh $COMPONENT $GITHUBREPO $TARGETDIR $VERSION_CMD") | crontab -
}
