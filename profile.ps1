Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -Colors @{ Parameter = 'White' }  # Fixes hard to read paramater color
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'  # set default output to utf8

# Add to path
$env:Path = "$env:PATH;$HOME\config\bin\windows\x86"

function ReloadPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    return
}

function GitLog {
    git log --graph --pretty=format:'%Cred%h%Creset - %Cgreen(%ad)%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=local
}
