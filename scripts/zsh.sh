#!/bin/sh -eux

# 
#  zsh configration
#

if ! rpm -q zsh >/dev/null; then
  dnf install -y zsh
fi

mkdir /etc/zsh
cat >> /etc/zshrc <<'EOF'
unsetopt BEEP

setopt autocd
setopt autopushd

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

ZPATH=/etc/zsh:$ZPATH
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source /etc/bash_completion.d
source /usr/share/bash-completion/completions

# configure history retention
HISTSIZE=10000              # How many lines of history to keep in memory
HISFILE=~/.zsh_history      # Where to save history to disk
SAVEHIST=10000              # Number of history entries to save to disk
setopt appendhistory        # Append history to the history file (no overwriting)
setopt sharehistory         # Share history across terminals, e.g. when using tmux
setopt incappendhistory     # Immediately append to the history file, not just when a term is killed

export LANG=en_US.UTF-8
PROMPT='%n%F{cyan}@%m%f:%3~%F{cyan}%# %f'

source /etc/zsh/aliases.zsh
source /etc/zsh/complete.zsh
source /etc/zsh/fzf.zsh
EOF

cat > /etc/zsh/aliases.zsh <<'EOF'
alias ll='ls -lh -F --group-directories-first --color=auto'
alias ls='ls -F --color=auto'
alias l='ls -F --color=auto'
alias vi='vim'

alias -g G='| grep -i'
alias -g H='| grep -zi'
alias -g L='| less'

alias d='dirs -v | head -10'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
EOF

echo "# /etc/zsh/complete.zsh" > /etc/zsh/complete.zsh

# install fzf

GH_RAW='https://raw.githubusercontent.com'
(
	cd /usr/bin
	curl -L "https://github.com/junegunn/fzf-bin/releases/download/0.23.1/fzf-0.23.1-linux_amd64.tgz" | tar xz
)
mkdir -p /usr/share/vim/vimfiles/plugin/start/fzf/plugin
curl -Lo /usr/share/vim/vimfiles/plugin/start/fzf/plugin/fzf.vim "$GH_RAW/junegunn/fzf/0.25.1/plugin/fzf.vim"
curl -Lo /usr/share/zsh/site-functions/_zsh "$GH_RAW/junegunn/fzf/0.25.1/shell/completion.zsh"
curl -Lo /etc/zsh/fzf.zsh "$GH_RAW/junegunn/fzf/0.25.1/shell/key-bindings.zsh"
curl -Lo /usr/bin/fzf-tmux "$GH_RAW/junegunn/fzf/0.25.1/bin/fzf-tmux" && chmod 0755 /usr/bin/fzf-tmux

sed -i 's#^root:#root:x:0:0:root:/root:/bin/zsh#' /etc/passwd
echo '# ~/.zshrc' > /root/.zshrc
echo '# ~/.zshrc' > /etc/skel/.zshrc
