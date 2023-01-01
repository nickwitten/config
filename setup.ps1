# If unable to run script, issue this
# Set-ExecutionPolicy Unrestricted
. ~/config/profile.ps1


########### Vim #####################
Copy-Item $HOME\config\_vimrc $HOME\_vimrc -Force | Out-Null
$vimplugpath = "$HOME/.vim/autoload/plug.vim"
if (-Not (Test-Path -Path $vimplugpath)) {
    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        ni $vimplugpath -Force | Out-Null
    echo "Installed Vim-Plug"
}

########## NVim ##################
$nvimconfig = "$env:LOCALAPPDATA/nvim"
$nvimrc = "$env:LOCALAPPDATA/nvim/init.vim"
if (-Not (Test-Path -Path $nvimconfig)) {
    mkdir -p $nvimconfig | Out-Null
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" >> $nvimrc
    echo "let &packpath=&runtimepath" >> $nvimrc
    echo "source ~/config/.vimrc" >> $nvimrc
    echo "NVIM CONFIGURED"
}

######## PowerShell ################
New-Item -ItemType File -Path $profile -Force | Out-Null
echo ". $HOME\config\profile.ps1" > $profile


###### Windows Terminal ############
Copy-Item ~\config\windowsterm.json ~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

