#!/usr/bin/bash


# Configuration file links
link ~/config/.vimrc ~/.vimrc 2> /dev/null
link ~/config/.tmux.conf ~/.tmux.conf 2> /dev/null
link ~/config/.zshrc ~/.zshrc 2> /dev/null

##### Requirements #####
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

#### Check for Curl #####
if ! command_exists curl; then
    echo "Missing curl, unable to install zsh and vim plugins"
    exit 1
fi

# Install zsh plugins
if ! [ -d $HOME/.zsh-themes ]; then
    mkdir -p "$HOME/.zsh-themes"
    if ! [ -d $HOME/.zsh-themes/pure ]; then
        git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh-themes"
    fi
fi

# Install vimplug
VIMPLUG_LOC=~/.vim/autoload/plug.vim
if [ ! -f ${VIMPLUG_LOC} ]; then
    curl -fLo ${VIMPLUG_LOC} --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
