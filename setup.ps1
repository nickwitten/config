# If unable to run script, issue this
# Set-ExecutionPolicy Unrestricted
. ~/config/profile.ps1

######### Packages ################

# Choco
try {
    choco --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    echo "Installed Chocolatey"
    choco feature enable -n useRememberedArgumentsForUpgrades
}

# Git
try {
    git --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    choco install git -y
    echo "Installed Git"
}

# Vim
try {
    vim --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    choco install vim -y
    echo "Installed Vim"
}

# Python 3.10
try {
    python310 --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    InstallPython "3.10"
}

# Python 3.8
try {
    python38 --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    InstallPython "3.8"
}


########### Vim #####################
$vimplugpath = "$HOME/vimfiles/autoload/plug.vim"
if (-Not (Test-Path -Path $vimplugpath)) {
    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        ni $vimplugpath -Force | Out-Null
    echo "Installed Vim-Plug"
}
Copy-Item ~/config/_vimrc ~/_vimrc -Force | Out-Null


######## PowerShell ################
New-Item -ItemType File -Path $profile -Force | Out-Null
echo ". $HOME\config\profile.ps1" > $profile


###### Windows Terminal ############
Copy-Item ~\config\windowsterm.json ~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

