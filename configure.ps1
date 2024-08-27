# If unable to run script, issue this
# Set-ExecutionPolicy Unrestricted

########### Vim #####################
New-Item -ItemType File -Path $HOME\.vimrc -Force | Out-Null
"source $HOME\config\.vimrc" | Out-File -FilePath $HOME\.vimrc
$vimplugpath = "$HOME\vimfiles\autoload\plug.vim"
if (-Not (Test-Path -Path $vimplugpath)) {
    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        ni $vimplugpath -Force | Out-Null
    echo "Installed Vim-Plug"
}

######## PowerShell ################
New-Item -ItemType File -Path $profile -Force | Out-Null
". $HOME\config\profile.ps1" | Out-File -FilePath $profile

