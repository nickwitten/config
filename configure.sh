#!/usr/bin/bash


# Configuration file links
link ~/config/.vimrc ~/.vimrc 2> /dev/null
link ~/config/.tmux.conf ~/.tmux.conf 2> /dev/null
link ~/config/.zshrc ~/.zshrc 2> /dev/null
link ~/config/.bashrc ~/.bashrc 2> /dev/null
mkdir -p ~/.config/nvim
link ~/config/init.vim ~/.config/nvim/init.vim 2> /dev/null

##### Git #####
if ! git config --list --global | grep user.email > /dev/null; then
    echo -e;
    read -p "Would you like to configure git for personal use? [y/n]" USER_CONFIRM
    if [ "${USER_CONFIRM}" = "y" ]; then
        git config --global user.email "nwitt12@gmail.com"
        git config --global user.name "Nick Witten"
        echo -e "GIT CONFIGURED"
    fi
fi

##### Requirements #####
command_exists() {
    command -v "$@" >/dev/null 2>&1
}
if ! command_exists curl; then
    echo "Missing curl, unable to install zsh and vim plugins"
    exit 1
fi

# Install zsh plugins
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

# Install vimplug
VIMPLUG_LOC=~/.vim/autoload/plug.vim
if [ ! -f ${VIMPLUG_LOC} ]; then
    curl -fLo ${VIMPLUG_LOC} --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
