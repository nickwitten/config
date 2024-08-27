# If unable to run script, issue this
# Set-ExecutionPolicy Unrestricted

########### Vim #####################
New-Item -ItemType File -Path $HOME\_vimrc -Force | Out-Null
echo "source ~/config/.vimrc" > $HOME\_vimrc
$vimplugpath = "$HOME/.vim/autoload/plug.vim"
if (-Not (Test-Path -Path $vimplugpath)) {
    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        ni $vimplugpath -Force | Out-Null
    echo "Installed Vim-Plug"
}

######## PowerShell ################
New-Item -ItemType File -Path $profile -Force | Out-Null
echo ". $HOME\config\profile.ps1" > $profile

