#!/bin/sh -eux

#
#  TMUX
#
#  Configures tmux to automatically attach session upon login
#  and detach session upon running "exit" with only a single
#  pane/window open OR upon running "logoff" with any amount
#  of panes/windows open.
#
#  To disable this functionality set TMUX_AUTO_ATTACH=0 before
#  /etc/profile.d/tmux.sh is sourced, e.g. in /etc/profile
#

if ! rpm -q tmux >/dev/null; then
  dnf install -y tmux
fi

echo 'Configuring tmux.'

echo 'Enabling tmux auto-attach.'
for file in /root/.zprofile /etc/skel/.zprofile; do
cat >> "$file" <<'EOF'
TMUX_AUTO_ATTACH=1

if [ -z "$TMUX" ] && [ -n "$TMUX_AUTO_ATTACH" ]; then
  [ -n "$SSH_CONNECTION" ] && TMUX_SESSION="ssh" || TMUX_SESSION="local"
  tmux attach-session -t $TMUX_SESSION || tmux new -s $TMUX_SESSION
fi
EOF
done

echo 'Configuring zsh to exit in a way that leaves tmux session intact.'
for file in /root/.zshrc /etc/skel/.zshrc; do
cat >> "$file" <<'EOF'
function logoff {
  tmux detach -P
}

function exit() {
  if [ "$TMUX" ] && [ "$TMUX_AUTO_ATTACH" -ne 0 ]; then
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
bindkey "^d" exit
EOF
done

cat > /etc/tmux.conf <<'EOF'
set -g status off
set -g pane-active-border-fg 'cyan'
set -g status-bg 'cyan'
EOF
