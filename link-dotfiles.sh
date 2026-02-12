#!/bin/bash
# Julio C. Pompa Puente <julio.c.pompa.puente@gmail.com>
# - - - - - - - - - 8< - - - - - - - - - 8< - - - - - - - - -

CONFIG_FILES='bash_aliases bash_profile bashrc gitconfig gitignore inputrc tmux.conf Xdefaults xinitrc'
CONFIG_DIRS='config vim'

MSG_LINK_EXISTS='ERROR That link exists!'
# - - - - - - - - - 8< - - - - - - - - - 8< - - - - - - - - -

for LINK in $CONFIG_FILES $CONFIG_DIRS; do
    if [[ -e ~/.$LINK ]]; then
        echo "${MSG_LINK_EXISTS} ~/.$LINK" | ccze -A
        /usr/bin/ls -dlah ~/.$LINK
    else
        ln -svf ~/.dotfiles/$LINK ~/.$LINK
    fi
done

