$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ps_support.ps1"


Write-Output "Install dotfiles-nvim in the machine"
Write-Output "-----------------------------"

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

$originPath = "$HOME\AppData\Local\nvim"
$destinationPath = "$HOME\repos\dotfiles\.config\nvim"

New-Item -ItemType Junction `
    -Path $originPath `
    -Target $destinationPath

Write-Output "Job's done!"

# run nvim to install all the plugins
nvim
