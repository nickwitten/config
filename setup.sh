#!/bin/bash


# Vim setup
if ! command -v vim &> /dev/null; then
    sudo apt-get install vim
    echo
    echo "VIM INSTALLED"
    echo
fi

if [ ! -f "~/.vimrc" ]; then
    echo 'source ~/config/.vimrc' > ~/.vimrc;
    echo
    echo "VIMRC CREATED"
    echo
fi

VIMPLUG_LOC="~/.vim/autoload/plug.vim"
if [ ! -f ${VIMPLUG_LOC} ]; then
    curl -fLo ${VIMPLUG_LOC} --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo
    echo "VIMPLUG INSTALLED"
    echo
fi


# Git setup 
git config --global user.email "nwitt12@gmail.com"
git config --global user.name "Nick Witten"

