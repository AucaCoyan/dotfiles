$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ps_support.ps1"


Write-Output "Install NvChad in the machine"
Write-Output "-----------------------------"
Write-Output ""

Write-Output "1. Cloning NvChad"

function Clone-NvChad {
    # remove nvim-data
    Remove-Item "$HOME\AppData\Local\nvim-data" -Recurse -Force

    $hasNvimLuaCustomDirectory = Test-Path "$HOME\AppData\Local\nvim"
    if ($hasNvimLuaCustomDirectory) {
        Remove-Item "$HOME\AppData\Local\nvim" -Recurse -Force
    }
    git clone https://github.com/NvChad/NvChad $HOME\AppData\Local\nvim --depth 1
    
}

Clone-NvChad

Write-Output "2. Making the symlinks"

$originPath = "$HOME\AppData\Local\nvim\lua\custom"
$destinationPath = "$HOME\repos\dotfiles\.config\preconfigured-nvim\NvChad\custom\"

New-Item -ItemType Junction -Path $originPath -Target $destinationPath

Write-Output "Job's done!"

## other stuff
# script to install normal nvim
# script to isntall kickstart nvim
#
