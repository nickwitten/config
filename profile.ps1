Set-PSReadLineOption -EditMode Emacs

function Prompt {
  $loc = $($executionContext.SessionState.Path.CurrentLocation);
  $out = "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
  $out += "$([char]27)]9;9;`"$loc`"$([char]27)\"
  return $out
}

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
AddPythonToPath

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
    echo "Add to path: "
    echo "$InstallDir"
    echo "$InstallDir\Scripts"
}
