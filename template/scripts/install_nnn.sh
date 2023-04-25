#!/bin/sh

#
#  Install: nnn
#

NNN_RELEASE='4.8'
ZSH_SHARED_DIR=/usr/share/zsh/site-functions
ZSH_CUSTOM_DIR=/etc/zsh

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v ncurses || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr 0)'

NNN_REPO='https://github.com/jarun/nnn'
NNN_ARCHIVE="nnn-static-$NNN_RELEASE.x86_64.tar.gz"
NNN_ENV_FILE=/etc/profile.d/nnn.sh
NNN_ZSH_FILE=$ZSH_CUSTOM_DIR/nnn.zsh
ADD_CONFIG_TO_SKEL=1
TEST_CMD='n -V'

mkdir -p $ZSH_CUSTOM_DIR
touch $NNN_ENV_FILE
chmod 0644 $NNN_ENV_FILE
chown root:root $NNN_ENV_FILE

printf "Installing command: nnn (%s)\n" "$NNN_RELEASE"

(
	cd /tmp
	curl -L "$NNN_REPO/releases/download/v$NNN_RELEASE/$NNN_ARCHIVE" | tar xz
	install nnn-static /usr/bin/nnn
)

cat >> $NNN_ENV_FILE <<'EOF'
export NNN_OPENER NNN_OPTS \
    NNN_PLUG NNN_COLORS NNN_TRASH    

USER_CFG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
PLUGIN_DIR="${USER_CFG_HOME}/nnn/plugins"

NNN_COLORS="6138"
NNN_OPTS="adEPp"
NNN_PLUG='t:treeview;z:fzz;p:preview-tui'

# Set nuke as default file opener when using nnn
# also available as a standalone command

NNN_OPENER="${PLUGIN_DIR}/nuke"
# -c option tells NNN to not user an GUI opener
[ "$NNN_OPTS" != "${NNN_OPTS/*c*}" ] \
    && NNN_OPTS="${NNN_OPTS}c"
      
EOF


cat >> $NNN_ZSH_FILE <<'EOF'
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn -${NNN_OPTS} "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        source "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

zle -N n
bindkey '^[f' n
EOF

printf "Installing integrations: vim & zsh plugins for nnn (%s)\n" "$NNN_RELEASE"

(
	cd /tmp
	curl -L "$NNN_REPO/releases/download/v$NNN_RELEASE/nnn-v$NNN_RELEASE.tar.gz" | tar xz
	cd "nnn-$NNN_RELEASE"

	chmod 644 ./misc/auto-completion/zsh/_nnn
	chown root.root ./misc/auto-completion/zsh/_nnn
	cp ./misc/auto-completion/zsh/_nnn $ZSH_SHARED_DIR/

	chmod 644 ./misc/quitcd/quitcd.bash_zsh
	chown root.root ./misc/quitcd/quitcd.bash_zsh
	cp ./misc/quitcd/quitcd.bash_zsh $ZSH_CUSTOM_DIR/nnn.zsh

)

printf "Installing plugins: nnn (%s)\n" "$NNN_RELEASE"

(
	cd /tmp/nnn-$NNN_RELEASE/plugins
	sh ./getplugs

	mkdir -pm 0700 $HOME/.local/bin
	echo 'PATH=$PATH:~/.local/bin' >> $HOME/.zprofile
	NNN_PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins"
	ln -s $NNN_PLUGIN_DIR/nuke $HOME/.local/bin/
	
)

cat >> $NNN_ENV_FILE <<'EOF'
# configure z integration with nnn
export NNN_PLUG="z:fzz;${NNN_PLUG}"

# configure nuke as file opener
export NNN_OPTS="${NNN_OTS}c"
export NNN_OPENER="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/nuke"
EOF

zsh -c 'eval $TEST_CMD'

echo "Succesfully configured nnn!"
