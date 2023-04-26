#!/bin/sh

#
#  Install: fzf
#

FZF_RELEASE='0.39.0'
ZSH_CUSTOM_DIR=/etc/zsh
ZSH_SHARED_DIR=/usr/share/zsh/site-functions
VIM_PLUG_DIR=/usr/share/vim/vimfiles/pack/plugins
FZF_VIM_DIR="$VIM_PLUG_DIR/start/fzf/plugin"

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr 0)'

FZF_REPO='https://github.com/junegunn/fzf'
TEST_CMD_FZF='fzf --version'
TEST_CMD_TMUX='fzf-tmux --version'
FZF_ARCHIVE="fzf-$FZF_RELEASE-linux_amd64.tar.gz"
FZF_ARCHIVE="fzf-$FZF_RELEASE-linux_arm64.tar.gz"

mkdir -p $VIM_PLUG_DIR
mkdir -p $FZF_VIM_DIR
mkdir -p $ZSH_CUSTOM_DIR

printf "Installing command: fzf (%s)\n" "$FZF_RELEASE"

(
  cd /tmp
  curl -L "$FZF_REPO/releases/download/$FZF_RELEASE/$FZF_ARCHIVE" | tar xz \
        && install fzf /usr/bin

  eval $TEST_CMD_FZF
)

printf "Installing command: fzf-tmux (%s)\n" "$FZF_RELEASE"

(
  cd /tmp
  curl -L "$FZF_REPO/archive/$FZF_RELEASE.tar.gz" | tar xz
  cd "fzf-$FZF_RELEASE"
  install bin/fzf-tmux /usr/bin \
  /tmp/fzf-$FZF_RELEASE/install --key-bindings --completion --update-rc
  eval $TEST_CMD_TMUX
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

echo "Successfully installed fzf!"
