#!/bin/sh -eux

#
#  VIM
#

VIM_PLUG_DIR=/usr/share/vim/vimfiles/pack/plugins/start
mkdir -p $VIM_PLUG_DIR/vim-polygot
(
  cd $VIM_PLUG_DIR/vim-polygot
  curl -L "https://github.com/sheerun/vim-polyglot/archive/v4.17.0.tar.gz" | tar xz
)

cat >> /etc/vimrc <<'EOD'
set belloff=all
if &t_Co > 2 || has ("gui_running")
  colorscheme industry
endif
EOD

