#!/bin/bash


command_exists() {
    command -v "$@" >/dev/null 2>&1
}

contains_match() {
    grep -q "$2" $1 >/dev/null 2>&1
}

##### Requirements #####
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
    if ! [ -d $HOME/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        if [ -f $HOME/.zshrc.pre-oh-my-zsh ]; then
            mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc
        else
            rm $HOME/.zshrc
        fi
        mkdir -p "$HOME/.oh-my-zsh/custom/themes"
        git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/custom/themes/pure"
    fi
    if ! contains_match ~/.zshrc "${ZSHRC_CMD}"; then
        echo ${ZSHRC_CMD} >> ~/.zshrc
	echo "ZSH CONFIGURED"
    fi
fi

##### VIM #####
VIMRC_CMD='source ~/config/.vimrc'
VIMPLUG_LOC=~/.vim/autoload/plug.vim
if command_exists vim; then
    if ! contains_match ~/.vimrc "${VIMRC_CMD}"; then
        echo -e ${VIMRC_CMD} >> ~/.vimrc;
	echo -e "VIM CONFIGURED"
    fi
    if [ ! -f ${VIMPLUG_LOC} ]; then
        curl -fLo ${VIMPLUG_LOC} --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo -e "VIMPLUG INSTALLED"
    fi
fi

##### NVIM #####
NVIMRC_LOC="${HOME}/.config/nvim"
if command_exists nvim; then
    if ! contains_match "${NVIMRC_LOC}/init.vim" "${VIMRC_CMD}"; then
	mkdir -p ${NVIMRC_LOC}
	echo -e "set runtimepath^=~/.vim runtimepath+=~/.vim/after\nlet &packpath=&runtimepath" >> "${NVIMRC_LOC}/init.vim";
	echo -e ${VIMRC_CMD} >> "${NVIMRC_LOC}/init.vim";
	echo -e "NVIM CONFIGURED"
    fi
fi

##### TMUX #####
TMUX_SOURCE='source ~/config/.tmux.conf'
if command_exists tmux; then
    if ! contains_match ~/.tmux.conf "${TMUX_SOURCE}"; then
        echo "${TMUX_SOURCE}" >> ~/.tmux.conf;
	echo -e "TMUX CONFIGURED"
    fi
fi

##### GIT #####
if ! git config --list --global | grep user.email > /dev/null; then
    echo -e;
    read -p "Would you like to configure git for personal use? [y/n]" USER_CONFIRM
    if [ "${USER_CONFIRM}" = "y" ]; then
	git config --global user.email "nwitt12@gmail.com"
	git config --global user.name "Nick Witten"
	echo -e "GIT CONFIGURED"
    fi
fi
