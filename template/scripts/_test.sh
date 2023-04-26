#!/bin/sh

# ORDER SCRIPTS ARE TO BE RUN IN:

set -ex

#./motd.sh
#./issue.sh
#./metadata.sh
#./sshd.sh
#./networking.sh
./configure_vim.sh
./configure_zsh.sh
./install_fzf.sh
./install_nnn.sh
./configure_tmux.sh
./install_bat.sh
./install_croc.sh
./install_fd.sh
./install_lnav.sh
./install_rg.sh
./install_z.sh
#./cleanup.sh
#./minimize.sh
