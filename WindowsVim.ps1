# If unable to run script, issue this
# set-ExecutionPolicy Unrestricted

mkdir ~/.vim

iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force

copy ~/config/_vimrc ~/_vimrc
copy ~/config/.vimrc ~/.vimrc

mkdir ~/.vim/backup
mkdir ~/.vim/undo
mkdir ~/.vim/swap

# git clone https://github.com/morhetz/gruvbox.git "~\vimfiles\pack\default\start\gruvbox"
