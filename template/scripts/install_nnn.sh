#!/bin/sh

#
#  Install: nnn
#

set -eux
set -o pipefail

ZSH_SHARED_DIR=/usr/share/zsh/site-functions
ZSH_CUSTOM_DIR=/etc/zsh
mkdir -p $ZSH_CUSTOM_DIR

NNN_RELEASE='4.0'
NNN_REPO='https://github.com/jarun/nnn'
NNN_ARCHIVE="nnn-static-$NNN_RELEASE.x86_64.tar.gz"
NNN_ENV_FILE=/etc/profile.d/nnn.sh
ADD_CONFIG_TO_SKEL=1
TEST_CMD='n -V'

touch $NNN_ENV_FILE
chmod 0644 $NNN_ENV_FILE
chown root:root $NNN_ENV_FILE

printf "Installing command: nnn (%s)\n" "$NNN_RELEASE"

(
	cd /tmp
	curl -L "$NNN_REPO/releases/download/v$NNN_RELEASE/$NNN_ARCHIVE" | tar xz
	install nnn-static /usr/bin/nnn
)

cat >> $NNN_ENV_FILE <<'EOF'
export NNN_COLORS="6138"
export NNN_OPTS="adE"
EOF

printf "Installing integrations: vim & zsh plugins for nnn (%s)\n" "$NNN_RELEASE"

(
	cd /tmp
	curl -L "$NNN_REPO/releases/download/v$NNN_RELEASE/nnn-v$NNN_RELEASE.tar.gz" | tar xz
	cd "nnn-$NNN_RELEASE"

	chmod 644 ./misc/auto-completion/zsh/_nnn
	chown root.root ./misc/auto-completion/zsh/_nnn
	cp ./misc/auto-completion/zsh/_nnn $ZSH_SHARED_DIR/

	chmod 644 ./misc/quitcd/quitcd.bash_zsh
	chown root.root ./misc/quitcd/quitcd.bash_zsh
	cp ./misc/quitcd/quitcd.bash_zsh $ZSH_CUSTOM_DIR/nnn.zsh

)

printf "Installing plugins: nnn (%s)\n" "$NNN_RELEASE"

(
	cd /tmp/nnn-$NNN_RELEASE/plugins
	sh ./getplugs

	mkdir -pm 0700 $HOME/.local/bin
	echo 'PATH=$PATH:~/.local/bin' >> $HOME/.zprofile
	NNN_PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins"
	ln -s $NNN_PLUGIN_DIR/nuke $HOME/.local/bin/
	
)

cat >> $NNN_ENV_FILE <<'EOF'
# configure z integration with nnn
export NNN_PLUG="z:fzz;${NNN_PLUG}"

# configure nuke as file opener
export NNN_OPTS="${NNN_OTS}c"
export NNN_OPENER="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/nuke"
EOF

zsh -c 'eval $TEST_CMD || {
	printf "\nFailed to install nnn (%s):\n" "$NNN_RELEASE" 
	printf "Command '%s' failed with status %s.\n\n" "$TEST_CMD" "$?"
	exit 1
}' || exit 1
