#!/bin/sh

#
#  VIM
#

echo 'Configuring vim.'

VIM_POLYGLOT_RELEASE='v4.17.0'
VIM_POLYGLOT_REPO='https://github.com/sheerun/vim-polyglot'

VIM_PLUG_DIR=/usr/share/vim/vimfiles/pack/plugins
mkdir -p $VIM_PLUG_DIR/start/vim-polygot

(
  cd $VIM_PLUG_DIR/start/vim-polygot || exit 1
  curl -sSL "$VIM_POLYGLOT_REPO/archive/$VIM_POLYGLOT_RELEASE.tar.gz" | tar xz --strip=1
)

cat >> /etc/vimrc <<'EOD'
set belloff=all
if &t_Co > 2 || has ("gui_running")
  colorscheme industry
endif
EOD

