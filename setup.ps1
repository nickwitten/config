# If unable to run script, issue this
# Set-ExecutionPolicy Unrestricted

######### Packages ################
try {
    choco --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    echo "Installed Chocolatey"
}
try {
    git --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    choco install git -y
    echo "Installed Git"
}
try {
    vim --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException] {
    choco install vim -y
    echo "Installed Vim"
}


########### Vim #####################
$vimplugpath = "$HOME/vimfiles/autoload/plug.vim"
if (-Not (Test-Path -Path $vimplugpath)) {
    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        ni $vimplugpath -Force | Out-Null
    echo "Installed Vim-Plug"
}
Copy-Item ~/config/_vimrc ~/_vimrc -Force | Out-Null


#### PowerShell Configuration ######
New-Item -ItemType File -Path $profile -Force | Out-Null
echo "~/config/profile.ps1" > $profile

### Windows Terminal ###############
Copy-Item ~\config\windowsterm.json ~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

