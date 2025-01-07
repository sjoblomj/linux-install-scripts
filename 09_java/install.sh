#!/bin/bash
source ../common/aliases.sh
source ../common/cronjobs.sh
source ../common/install.sh
programs="$@"

if [[ "$programs" =~ "mvntree" ]]; then
	if [ ! -d $HOME/code/mvntree ]; then
		git clone https://github.com/sjoblomj/mvntree.git $HOME/code/mvntree
		echo 'source $HOME/code/mvntree/.mvntree' >> $HOME/.zshrc
		add_cronjob_to_check_git_repository "$HOME/code/mvntree"
	fi
	programs=$(echo "${programs}" | sed "s/mvntree//g")
fi

if [[ "$programs" =~ "maven" ]]; then
	make_alias "alias mci='mvn clean install'"
fi

if [[ "$programs" =~ "bazel" ]]; then
	if [ $(is_ubuntu) ]; then
		install_programs apt-transport-https curl gnupg
		curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
		sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
		sudo apt-get update
	fi
fi

install_programs ${programs}
