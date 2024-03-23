$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ps_support.ps1"


Write-Output "Install kickstart.nvim in the machine"
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

Write-Host "`nCloning kickstart.nvim (upstream)" -ForegroundColor White
git clone https://github.com/nvim-lua/kickstart.nvim $HOME\AppData\Local\nvim --depth 1


# Write-Host "`nMaking the symlinks" -ForegroundColor White
# Write-Output "2. Making the symlinks"

# $originPath = "$HOME\AppData\Local\nvim\lua\custom"
# $destinationPath = "$HOME\repos\dotfiles\.config\preconfigured-nvim\NvChad\custom\"

# New-Item -ItemType Junction `
#     -Path $originPath `
#     -Target $destinationPath

Write-Output "Job's done!"

# run nvim to install all the plugins
nvim
