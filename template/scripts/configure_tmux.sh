#!/bin/sh

#
#  TMUX
#
#  Configures tmux to automatically attach session upon login
#  and detach session upon running "exit" with only a single
#  pane/window open OR upon running "logout" with any amount
#  of panes/windows open.
#
#  To disable this functionality set TMUX_AUTO_ATTACH to any
#  value other than 1.
#

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v ncurses || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr 0)'

if ! rpm -q tmux >/dev/null; then
  dnf install -y tmux
fi

echo 'Configuring tmux.'

echo 'Enabling tmux auto-attach.'
for file in /root/.zprofile /etc/skel/.zprofile; do
cat >> "$file" <<'EOF'
## BEGIN TMUX AUTO-ATTACH FUNCTIONALITY 
#
# The lines below cause a tmux session to automatically attach upon login.
# If a tmux session does not exist then one will automatically be created.
#
# For debugging and to prevent lock-out this feature is only enabled on tty1
# by default. To change this, remove/modify the last condition in the if
# statement.
#
# The functionality provided by the code below is complemented by code
# placed in ~/.zshrc which logs the user off in a way that leaves the current
# tmux session intact, detached, and available for automatic attachment by the 
# code below on next login.
#
# To disable the functionality provided by this code and the complementary
# code in ~/.zshrc either set TMUX_AUTO_ATTACH to a value other than 1 in 
# ~/.zprofile below. If these files are inaccessible because the user is not
# logged in, log in on a tty other than tty1 and edit ~/.zprofile as mentioned.
#
TMUX_AUTO_ATTACH=1
#
if [ -z "$TMUX" ] && [ "$TMUX_AUTO_ATTACH" -eq 1 ] && [ `tty` = '/dev/tty1' ]; then
[ -n "$SSH_CONNECTION" ] && TMUX_SESSION="ssh" || TMUX_SESSION="local"
tmux attach-session -t $TMUX_SESSION || tmux new -s $TMUX_SESSION
fi
#
## END TMUX AUTO-ATTACH FUNCTIONALITY 
EOF
done

echo 'Configuring zsh to exit in a way that leaves tmux session intact.'

for file in /root/.zshrc /etc/skel/.zshrc; do
cat >> "$file" <<'EOF'
## BEGIN TMUX AUTO-ATTACH FUNCTIONALITY 
#
# The lines below cause a tmux session to detach before a user logs off,
# allowing the tmux session to be to automatically attach upon logging back in.
#
# For debugging and to prevent lock-out this feature is only enabled on tty1
# by default. To change this, remove/modify the last condition in the if
# statement.

# The code below over-writes some zsh defaults which control how, a shell is
# exited in such a way that the current tmux session is left intact. Namely,
# the complementary code over-writes the operation of CTRL-D as well as the
# zsh builtins 'logout' & 'exit'
#
# To disable the functionality provided by this code and the complementary
# code in ~/.zshrc either set TMUX_AUTO_ATTACH to a value other than 1 in 
# ~/.zprofile below. If these files are inaccessible because the user is not
# logged in, log in on a tty other than tty1 and edit ~/.zprofile as mentioned.
#
if [ $TMUX_AUTO_ATTACH -eq 1 ] && [ `tty` = '/dev/tty1' ]; then
function logoff {
  tmux detach -P
}
function exit() {
  if [ "$TMUX" ] && [ "$TMUX_AUTO_ATTACH" -eq 1 ]; then
    n_panes="$( tmux list-panes | wc -l )"
    n_windows="$( tmux list-windows | wc -l )"

    if [ $n_panes -gt 1 ] || [ $n_windows -gt 1 ]; then
      unset -f exit && exit
    else
      logoff
    fi
  else
    unset -f exit && exit
  fi
}
zle -N exit
stty -a | tr ';' '\012' | grep -q 'eof = \^D' && stty eof undef
bindkey "^D" exit
fi 
#
## END TMUX AUTO-ATTACH FUNCTIONALITY 
EOF
done

cat > /etc/tmux.conf <<'EOF'
set -g status off
set -g pane-active-border-fg 'cyan'
set -g status-bg 'cyan'
EOF

echo "Succesfully configured tmux!"

echo "Succesfully configured tmux!"
