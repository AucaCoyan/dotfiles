# imports for autocompletion
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

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
fnm env --use-on-cd --version-file-strategy=recursive | Out-String | Invoke-Expression
# more on `fnm` autocompletion below!


# catppuccin theme for FZF
$ENV:FZF_DEFAULT_OPTS = @"
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"@

function f {
    $directories = @(
        "$HOME\repos",
        "$HOME\other-repos",
        "$HOME\other-repos\espanso",
        "$HOME\other-repos\nu",
        "$HOME\workspace",
        "$HOME\workspace\private"
    )

    $fdOutput = fd --max-depth 1 --min-depth 1 --type directory --hidden --no-ignore --ignore-vcs --exclude node_modules -- . $directories | Out-String

    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        $selectedDirectory = $fdOutput | fzf | Out-String -NoNewline
    }
    else {
        Write-Warning "fzf is not installed. Using the first directory found by fd."
        $selectedDirectory = ($fdOutput -split "`r`n")[0].Trim().Trim()
    }

    if ($selectedDirectory) {
        try {
            Set-Location -Path $selectedDirectory
            return $selectedDirectory
        }
        catch {
            Write-Error "Failed to change directory to '$selectedDirectory': $($_.Exception.Message)"
            return $null
        }
    }
    else {
        Write-Warning "No directory selected."
        return $null
    }
}


# setup the node gyp version
$env:NODE_GYP_FORCE_PYTHON = "$HOME\AppData\Roaming\uv\python\cpython-3.10.18-windows-x86_64-none\python.exe"

