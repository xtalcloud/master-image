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
ADD_CONFIG_TO_SKEL=1
TEST_CMD='n -V'

printf "Installing command: nnn (%s)\n" "$NNN_RELEASE"

(
	cd /tmp
	curl -L "$NNN_REPO/releases/download/v$NNN_RELEASE/$NNN_ARCHIVE" | tar xz
	install nnn-static /usr/bin/nnn

)

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
	cd /tmp/nnn-$NNN_RELEASE
	mkdir -pm 0700 /root/.config/nnn
	chown root.root /root/.config/nnn
	cp -r ./plugins /root/.config/nnn/

	if [ $ADD_CONFIG_TO_SKEL -eq 1 ]; then
		NNN_PLUGINS_SKEL_DIR=/etc/skel/.config/nnn/plugins
		NNN_SKEL_TEST_CMD="find $NNN_PLUGINS_SKEL_DIR/ -type f"

		mkdir -pm 0700 /etc/skel/.config/nnn
		cp -r /root/.config/nnn/* /etc/skel/.config/nnn/

		eval $NNN_SKEL_TEST_CMD || {
			printf "Failed to copy nnn plugins (%s) to /etc/skel\n:" "$NNN_RELEASE" 
			printf "Command '%s' failed with status %s.\n" "$NNN_SKEL_TEST_CMD" "$?"
			exit 1
		}
	fi
)

cat >> /etc/profile.d/nnn.sh <<'EOF'
export NNN_COLORS="6138"
export NNN_OPTS="dE"
EOF

chmod 0644 /etc/profile.d/nnn.sh
chown root.root /etc/profile.d/nnn.sh

zsh -c 'eval $TEST_CMD || {
	printf "Failed to install nnn (%s)\n:" "$NNN_RELEASE" 
	printf "Command '%s' failed with status %s.\n" "$TEST_CMD" "$?"
	exit 1
}' || exit 1
