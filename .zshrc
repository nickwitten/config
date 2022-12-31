# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(gitfast z colored-man-pages)

source $ZSH/oh-my-zsh.sh

# Pure Prompt Setup
fpath+=($ZSH/custom/themes/pure)
autoload -U promptinit; promptinit
prompt pure

source ${HOME}/config/alias.sh
source ${HOME}/config/env.sh
