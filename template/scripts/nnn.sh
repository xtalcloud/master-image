#!/bin/sh

#
#  NNN
#

set -eux
set -o pipefail

echo 'Installing nnn.'

ZSH_SHARED_DIR=/usr/share/zsh/site-functions
ZSH_CUSTOM_DIR=/etc/zsh
mkdir -p $ZSH_CUSTOM_DIR

NNN_RELEASE='3.6'
NNN_REPO='https://github.com/jarun/nnn'
NNN_ARCHIVE="nnn-static-$NNN_RELEASE.x86_64.tar.gz"
(
	cd /tmp

	curl -L "$NNN_REPO/releases/download/v$NNN_RELEASE/$NNN_ARCHIVE" | tar xz
	install nnn-static /usr/bin/nnn

	curl -L "$NNN_REPO/releases/download/v$NNN_RELEASE/nnn-v$NNN_RELEASE.tar.gz" | tar xz
	&& cd "nnn-$NNN_RELEASE"

	chmod 644 ./misc/auto-completion/zsh/_nnn
	chown root:root ./misc/auto-completion/zsh/_nnn
	cp ./misc/auto-completion/zsh/_nnn $ZSH_SHARED_DIR/

	chmod 644 ./misc/quitcd/quitcd.bash_zsh
	chown root:root ./misc/quitcd/quitcd.bash_zsh
	cp ./misc/quitcd/quitcd.bash_zsh $ZSH_CUSTOM_DIR/nnn.zsh

	mkdir -p /etc/skel/.config/nnn
	chmod 0700 /etc/skel/.config/nnn
	cp -r ./plugins /etc/skel/.config/nnn/

	mkdir -p /root/.config/nnn
	chmod 0700 /root/.config/nnn
	cp -r ./plugins /root/.config/nnn/
)

cat >> /etc/profile.d/nnn.sh <<'EOF'
export NNN_COLORS="6138"
EOF
