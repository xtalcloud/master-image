#!/bin/sh

#
#  Configure: vim
#

VIM_PLUG_DIR=/usr/share/vim/vimfiles/pack/plugins
VIM_POLYGLOT_RELEASE='4.17.0'

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr 0)'

echo 'Configuring vim.'

if ! rpm -q vim >/dev/null; then
  dnf install -y vim
fi

VIM_POLYGLOT_REPO='https://github.com/sheerun/vim-polyglot'
TEST_CMD="vim -c ':set t_ti= t_te= nomore' -c 'scriptnames|q!' 2>/dev/null| grep -q vim-polyglot"

mkdir -p $VIM_PLUG_DIR/start/vim-polyglot

printf "Installing vim plugin: vim-polyglot (v%s)\n" "$VIM_POLYGLOT_RELEASE"

(
  cd $VIM_PLUG_DIR/start/vim-polyglot || exit 1
  curl -sSL "$VIM_POLYGLOT_REPO/archive/v$VIM_POLYGLOT_RELEASE.tar.gz" | tar xz --strip=1
)

cat >> /etc/vimrc <<'EOD'
set belloff=all
if &t_Co > 2 || has ("gui_running")
  colorscheme industry
endif
EOD

cat >> /etc/profile.d/sh.local <<'EOD'
export EDITOR=vim
export VISUAL=vim
EOD

eval $TEST_CMD
echo "Success fully configured vim!"
