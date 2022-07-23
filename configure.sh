#!/bin/bash


command_exists() {
    command -v "$@" >/dev/null 2>&1
}

contains_match() {
    grep -q "$2" $1 >/dev/null 2>&1
}

if ! command_exists curl || ! command_exists git; then
    echo "Unable to configure, missing curl or git"
    exit 1
fi

##### BASH #####
BASHRC_CMD='source ~/config/.bashrc'
if ! contains_match ~/.bashrc "${BASHRC_CMD}"; then
    echo ${BASHRC_CMD} >> ~/.bashrc
    echo "BASH CONFIGURED"
fi;

##### ZSH #####
ZSHRC_CMD='source ~/config/.zshrc'
if command_exists zsh; then
    if ! contains_match ~/.zshrc "${ZSHRC_CMD}"; then
        echo ${ZSHRC_CMD} >> ~/.zshrc
    fi
    if ! [ -d $HOME/.oh-my-zsh ]; then
        mkdir -p "$HOME/.oh-my-zsh/custom/themes"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/custom/themes/pure"
    fi
    echo "ZSH CONFIGURED"
fi

##### VIM #####
VIMRC_CMD='source ~/config/.vimrc'
VIMPLUG_LOC=~/.vim/autoload/plug.vim
if command_exists vim; then
    if ! contains_match ~/.vimrc "${VIMRC_CMD}"; then
        echo -e ${VIMRC_CMD} >> ~/.vimrc;
    fi
    if [ ! -f ${VIMPLUG_LOC} ]; then
        curl -fLo ${VIMPLUG_LOC} --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo -e "VIMPLUG INSTALLED"
    fi
    echo -e "VIM CONFIGURE"
fi

##### TMUX #####
TMUX_SOURCE='source ~/config/.tmux.conf'
if command_exists tmux; then
    if ! contains_match ~/.tmux.conf "${TMUX_SOURCE}"; then
        echo "${TMUX_SOURCE}" >> ~/.tmux.conf;
    fi
    echo -e "TMUX CONFIGURED"
fi

##### GIT #####
# # Git setup 
# git config --global user.email "nwitt12@gmail.com"
# git config --global user.name "Nick Witten"
# echo -e "GIT CONFIGURED"
