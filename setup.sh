#!/bin/bash


# Vim setup
if ! command -v vim &> /dev/null; then
    sudo apt-get install vim
    echo
    echo "VIM INSTALLED"
    echo
fi

# Ctags setup
if ! command -v ctags &> /dev/null; then
    sudo apt-get install ctags
    echo
    echo "CTAGS INSTALLED"
    echo
fi

if [ ! -f ~/.vimrc ]; then
    echo 'source ~/config/.vimrc' > ~/.vimrc;
    echo
    echo "VIMRC CREATED"
    echo
fi

VIMPLUG_LOC=~/.vim/autoload/plug.vim
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
echo
echo "GIT CONFIGURED"
echo

# Tmux setup
if ! command -v tmux &> /dev/null; then
    sudo apt-get install tmux
    echo
    echo "TMUX INSTALLED"
    echo
fi
echo 'source ~/config/.tmux.conf' >> ~/.tmux.conf
echo 'alias tmux="TERM=screen-256color-bce tmux"' >> ~/.bashrc
echo
echo "TMUX CONFIGURED"
echo
