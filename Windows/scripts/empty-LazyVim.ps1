$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ps_support.ps1"


Write-Output "Clone empty LazyVim in the machine"
Write-Output "-----------------------------"
Write-Output ""

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

Write-Host "`nCloning LazyVim" -ForegroundColor White
git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim


Write-Host "`nRemoving .git folder" -ForegroundColor White
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force

Write-Host "`nMaking symlink ~/AppData/Local/nvim/lua/ to ~/repos/dotfiles/.config/preconfigured-nvim/lazyvim/" -ForegroundColor White
$hasNvimConfigDirectory = Test-Path "$HOME\AppData\Local\nvim\lua\"
if ($hasNvimConfigDirectory) {
    Write-Host "`nRemoving ~/AppData/Local/nvim/lua/" -ForegroundColor White
    Remove-Item "$HOME\AppData\Local\nvim\lua\" -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path "$HOME/AppData/Local/nvim/lua/" -Target "$HOME\repos\dotfiles\.config\preconfigured-nvim\lazyvim\"

Write-Host "Done! ✅" -ForegroundColor Green

# run nvim to install all the plugins
nvim
