Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -Colors @{ Parameter = 'White' }  # Fixes hard to read paramater color

function Prompt {
  $loc = $($executionContext.SessionState.Path.CurrentLocation);
  $out = "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
  $out += "$([char]27)]9;9;`"$loc`"$([char]27)\"
  return $out
}

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'  # set default output to utf8

$env:BAT_THEME = 'gruvbox-dark'
$env:FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
$env:FZF_DEFAULT_OPTS = '-m --height 50% --border'

# Add to path
$env:Path = "$env:PATH;$HOME\config\sbin"
$env:Path = "$env:PATH;$HOME\config\bin\windows\x86"
$env:Path = "$env:PATH;$HOME\config\portable\nvim-win64\bin"


function ReloadPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    return
}

########## PYTHON ###################
$PythonInstallPath = "$env:LOCALAPPDATA\Programs\Python"
$DefaultPythonVersionNoDot = "310"
function AddPythonToPath {
    $env:Path = "$PythonInstallPath\Python$DefaultPythonVersionNoDot\Scripts;$env:Path"
    $env:Path = "$PythonInstallPath\Python$DefaultPythonVersionNoDot;$env:Path"
    # Add each python installation to path
    Get-ChildItem $PythonInstallPath | Where-Object { $_.name -like "Python*" } | ForEach-Object {
        if (";$env:Path;" -notlike "*;$PythonInstallPath\$_.name;*") {
            $env:Path += ";" + $_.FullName
            $env:Path += ";" + $_.FullName + "\Scripts"
        }
    }
}
if (Test-Path -Path $PythonInstallPath) {
    AddPythonToPath
}

function InstallPython {

    param ($PythonVersion)

    $PythonVersionNoDot = $PythonVersion -replace '[.]',''
    $InstallDir = "$PythonInstallPath\Python$PythonVersionNoDot"

    $pycmd = "choco install python3 --version $PythonVersion --side-by-side -y --params `"/installdir:$InstallDir`""

    Invoke-Expression "$pycmd"

    Copy-Item $InstallDir\python.exe $InstallDir\python$PythonVersionNoDot.exe

    $env:Path += ";$InstallDir"

    Invoke-Expression "python$PythonVersionNoDot -m ensurepip --upgrade"

    AddPythonToPath
    echo "Added to path: "
    echo "$InstallDir"
    echo "$InstallDir\Scripts"
}

function searchVENV {
    Get-ChildItem | Where-Object { $_.name -like "venv" } | ForEach-Object {
        .\venv\Scripts\activate
    }
}
searchVENV

function GitLog {
    git log --graph --pretty=format:'%Cred%h%Creset - %Cgreen(%ad)%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=local
}
