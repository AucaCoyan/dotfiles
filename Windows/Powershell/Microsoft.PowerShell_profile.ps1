# imports for autocompletion
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# scoop autocompletion
Import-Module scoop-completion

# Terminal icons and colors for ls
Import-Module -Name Terminal-Icons

# Full path of scripting directory 
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.2#psscriptroot
$profileDir = $PSScriptRoot;

# autocompletions
& "$profileDir\autocompletions\deno.ps1"
& "$profileDir\autocompletions\fnm.ps1"

# Produce UTF-8 by default
# https://news.ycombinator.com/item?id=12991690
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"


# zoxide v0.8.0+
Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
    })

# a bunch of aliases nice functions
function open($file) {
    invoke-item $file
}

function explorer {
    explorer.exe .
}

# oh my posh config
oh-my-posh init pwsh --config ~\repos\dotfiles\Windows\oh-my-posh.config.json | Invoke-Expression

# Predictive intellisense
Import-Module PSReadLine
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}
else {
    Write-Output "HistoryAndPlugin not enabled"
}
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete #set \t to autocomplete key

# intellitent quote (' ") smart pair completion
Set-PSReadLineKeyHandler -Chord '"', "'" `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
        # Just move the cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        # Insert matching quotes, move cursor to be in between the quotes
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}

# `fnm`:
# load the `.node-version` or `.nvmrc` file on cd and load the NodeJS version correctly
fnm env --use-on-cd | Out-String | Invoke-Expression
# more on `fnm` autocompletion below!


# -------------------------------------------------------------------------------------
# chocolatey autocompletion
# Be aware that if you are missing these line from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

Invoke-Expression nu
