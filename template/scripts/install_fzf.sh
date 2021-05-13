#!/bin/sh

#
#  Install: fzf
#

VIM_PLUG_DIR=/usr/share/vim/vimfiles/pack/plugins
mkdir -p $VIM_PLUG_DIR

FZF_VIM_DIR="$VIM_PLUG_DIR/start/fzf/plugin"
mkdir -p $FZF_VIM_PATH

ZSH_SHARED_DIR=/usr/share/zsh/site-functions
ZSH_CUSTOM_DIR=/etc/zsh
mkdir -p $ZSH_CUSTOM_DIR

FZF_RELEASE='0.26.0'
FZF_REPO='https://github.com/junegunn/fzf'
FZF_ARCHIVE="fzf-$FZF_RELEASE-linux_amd64.tar.gz"
TEST_CMD_FZF='fzf --version'
TEST_CMD_TMUX='fzf-tmux --version'

printf "Installing command: fzf (%s)\n" "$FZF_RELEASE"

(
cd /tmp
curl -L "$FZF_REPO/releases/download/$FZF_RELEASE/$FZF_ARCHIVE" | tar xz \
	&& install fzf /usr/bin

set +x
eval $TEST_CMD_FZF | grep -q "$FZF_RELEASE" || {
	printf "\nFailed to install fzf (%s):\n" "$FZF_RELEASE" 
	printf "Command '%s' failed with status %s.\n\n" "$TEST_CMD_FZF" "$?"
	exit 1
}
set -x
)

printf "Installing command: fzf-tmux (%s)\n" "$FZF_RELEASE"

(
cd /tmp
curl -L "$FZF_REPO/archive/$FZF_RELEASE.tar.gz" | tar xz \
	&& cd "fzf-$FZF_RELEASE" \
	&& install bin/fzf-tmux /usr/bin

set +x
eval $TEST_CMD_TMUX | grep -q "$FZF_RELEASE" || {
	printf "\nFailed to install fzf-tmux (%s):\n" "$FZF_RELEASE" 
	printf "Command '%s' failed with status %s.\n\n" "$TEST_CMD_TMUX" "$?"
	exit 1
}
set -x
)

printf "Installing integrations: vim & zsh plugins for fzf (%s)\n" "$FZF_RELEASE"

(
cd /tmp/fzf-$FZF_RELEASE
cp ./plugin/fzf.vim $FZF_VIM_DIR/
cp ./shell/completion.zsh $ZSH_SHARED_DIR/_fzf
cp ./shell/key-bindings.zsh $ZSH_CUSTOM_DIR/fzf.zsh

cat > /etc/profile.d/fzf.sh <<'EOF'
export FZF_TMUX_OPTS="-d 40%"
export FZF_CTRL_R_OPTS="--margin 15%,5%"
EOF
)




