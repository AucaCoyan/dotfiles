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
