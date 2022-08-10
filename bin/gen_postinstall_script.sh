#!/bin/sh

# prints to standard out the concatentation
# of these files, so the commands can be run
# from a script in the order that Packer would
# execute them during bootstrapping

# the sed command will filter out the shebangl ines (except the first)
sed -e '/^\(#!\)/{x;/./!{x;h;b;};d}' << cat \
../template/scripts/motd.sh \
../template/scripts/issue.sh \
../template/scripts/metadata.sh \
../template/scripts/sshd.sh \
../template/scripts/networking.sh \
../template/scripts/configure_vim.sh \
../template/scripts/install_fzf.sh \
../template/scripts/install_nnn.sh \
../template/scripts/configure_zsh.sh \
../template/scripts/configure_tmux.sh \
../template/scripts/install_bat.sh \
../template/scripts/install_croc.sh \
../template/scripts/install_fd.sh \
../template/scripts/install_lnav.sh \
../template/scripts/install_rg.sh \
../template/scripts/install_z.sh \
../template/scripts/cleanup.sh \
../template/scripts/minimize.sh
