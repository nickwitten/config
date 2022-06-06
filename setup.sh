#!/bin/bash


command_exists() {
    command -v "$@" >/dev/null 2>&1
}

contains_match() {
    grep -q "$2" $1 >/dev/null 2>&1
}

# My bashrc addons
BASHRC_CMD='source ~/config/.bashrc'
if ! contains_match ~/.bashrc "${BASHRC_CMD}"; then
    echo ${BASHRC_CMD} >> ~/.bashrc
fi;

# Vim setup
if ! command_exists vim; then
    sudo apt-get install vim
    echo -e "\nVIM INSTALLED\n"
fi

# Curl setup
if ! command_exists curl; then
    sudo apt-get install curl
    echo -e "\nCURL INSTALLED\n"
fi

if ! command_exists zsh; then
    sudo apt-get install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/custom/themes"
    echo -e "\nZSH INSTALLED\n"
    echo 'source ~/config/.zshrc' > ~/.zshrc
fi

echo -e "\nCONSIDER RUNNING FONT INSTALL SCIPT IN FONTS/\n"

# Ctags setup
if ! command_exists ctags; then
    sudo apt-get install exuberant-ctags
    echo -e "\nCTAGS INSTALLED\n"
fi

# Ripgrep setup
if ! command_exists rg; then
    sudo apt-get install ripgrep
    echo -e "\nRIPGREP INSTALLED\n"
fi

# File fuzzy finder setup
if ! command_exists fzf; then
    sudo apt-get install fzf
    echo -e "\nFZF INSTALLED\n"
fi

if [ ! -f ~/.vimrc ]; then
    echo -e 'source ~/config/.vimrc' > ~/.vimrc;
    echo -e "\nVIMRC CREATED\n"
fi

VIMPLUG_LOC=~/.vim/autoload/plug.vim
if [ ! -f ${VIMPLUG_LOC} ]; then
    curl -fLo ${VIMPLUG_LOC} --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo -e "\nVIMPLUG INSTALLED\n"
fi


# Git setup 
git config --global user.email "nwitt12@gmail.com"
git config --global user.name "Nick Witten"
echo -e "\nGIT CONFIGURED\n"

# Tmux setup
if ! command_exists tmux; then
    sudo apt-get install tmux
    echo -e "\nTMUX INSTALLED\n"
fi
TMUX_SOURCE='source ~/config/.tmux.conf'
if ! contains_match ~/.tmux.conf "${TMUX_SOURCE}"; then
    echo "${TMUX_SOURCE}" >> ~/.tmux.conf;
fi
echo -e "\nTMUX CONFIGURED\n"
