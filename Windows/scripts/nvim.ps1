$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ps_support.ps1"


Write-Output "Install dotfiles-nvim in the machine"
Write-Output "-----------------------------"
Write-Output ""

Write-Output "1. Removing `/nvim` and `/nvim-data` "

# remove nvim-data
$hasnNvimDataDirectory = Test-Path "$HOME\AppData\Local\nvim-data"
if ($hasnNvimDataDirectory) {
    Write-Host "`nRemoving nvim-data " -ForegroundColor White
    Remove-Item "$HOME\AppData\Local\nvim-data" -Recurse -Force
}

# remove nvim
$hasNvimLuaCustomDirectory = Test-Path "$HOME\AppData\Local\nvim"
if ($hasNvimLuaCustomDirectory) {
    Write-Host "`nRemoving nvim " -ForegroundColor White
    Remove-Item "$HOME\AppData\Local\nvim" -Recurse -Force
}

Write-Host "`nMaking the symlinks" -ForegroundColor White
Write-Output "2. Making the symlinks"

try {
    $originPath = "$HOME\AppData\Local\nvim"
    $destinationPath = "$HOME\repos\dotfiles\.config\nvim"

    # delete the folder if it exists
    $LocalStateExits = Test-Path $originPath
    if ($LocalStateExits) {
        Write-Host "$LocalStateExits dir found! Removing..." -ForegroundColor Yellow
        Remove-Item $originPath -Recurse -Force
    }

    # symlink the nvim folder
    New-Item -ItemType SymbolicLink -Path $originPath -Target $destinationPath
}
catch { Write-Warning $_ }
Write-Output "Job's done!"

# run nvim to install all the plugins
nvim
