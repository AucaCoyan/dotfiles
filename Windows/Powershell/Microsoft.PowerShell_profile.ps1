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
        "$HOME\all-repos\",
        "$HOME\workspace",
        "$HOME\workspace\botmaker",
        "$HOME\workspace\dataflow",
        "$HOME\workspace\gcp-source",
        "$HOME\workspace\private"
    )

    $fdOutput = fd --max-depth 1 --min-depth 1 --type directory --hidden --no-ignore --ignore-vcs --exclude node_modules -- . $directories | Out-String

    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        $selectedDirectory = $fdOutput | fzf | Out-String
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

# -------------------------------------------------------------------------------------
# Catppuccin
# Import the module
Import-Module Catppuccin

# Set a flavor for easy access
$Flavor = $Catppuccin['Mocha']

# Modified from the built-in prompt function at: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_prompts
function prompt {
    $(if (Test-Path variable:/PSDebugContext) { "$($Flavor.Red.Foreground())[DBG]: " }
        else { '' }) + "$($Flavor.Teal.Foreground())PS $($Flavor.Yellow.Foreground())" + $(Get-Location) +
    "$($Flavor.Green.Foreground())" + $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> ' + $($PSStyle.Reset)
}
# The above example requires the automatic variable $PSStyle to be available, so can be only used in PS 7.2+
# Replace $PSStyle.Reset with "`e[0m" for PS 6.0 through PS 7.1 or "$([char]27)[0m" for PS 5.1


$Colors = @{
    # Largely based on the Code Editor style guide
    # Emphasis, ListPrediction and ListPredictionSelected are inspired by the Catppuccin fzf theme

    # Powershell colours
    ContinuationPrompt     = $Flavor.Teal.Foreground()
    Emphasis               = $Flavor.Red.Foreground()
    Selection              = $Flavor.Surface0.Background()

    # PSReadLine prediction colours
    InlinePrediction       = $Flavor.Overlay0.Foreground()
    ListPrediction         = $Flavor.Mauve.Foreground()
    ListPredictionSelected = $Flavor.Surface0.Background()

    # Syntax highlighting
    Command                = $Flavor.Blue.Foreground()
    Comment                = $Flavor.Overlay0.Foreground()
    Default                = $Flavor.Text.Foreground()
    Error                  = $Flavor.Red.Foreground()
    Keyword                = $Flavor.Mauve.Foreground()
    Member                 = $Flavor.Rosewater.Foreground()
    Number                 = $Flavor.Peach.Foreground()
    Operator               = $Flavor.Sky.Foreground()
    Parameter              = $Flavor.Pink.Foreground()
    String                 = $Flavor.Green.Foreground()
    Type                   = $Flavor.Yellow.Foreground()
    Variable               = $Flavor.Lavender.Foreground()
}

# Set the colours
Set-PSReadLineOption -Colors $Colors


# The following colors are used by PowerShell's formatting
# Again PS 7.2+ only
$PSStyle.Formatting.Debug = $Flavor.Sky.Foreground()
$PSStyle.Formatting.Error = $Flavor.Red.Foreground()
$PSStyle.Formatting.ErrorAccent = $Flavor.Blue.Foreground()
$PSStyle.Formatting.FormatAccent = $Flavor.Teal.Foreground()
$PSStyle.Formatting.TableHeader = $Flavor.Rosewater.Foreground()
$PSStyle.Formatting.Verbose = $Flavor.Yellow.Foreground()
$PSStyle.Formatting.Warning = $Flavor.Peach.Foreground()

# Invoke-Expression nu
# unnecesary
# install the shell in windows terminal here:
# https://www.nushell.sh/book/default_shell.html
