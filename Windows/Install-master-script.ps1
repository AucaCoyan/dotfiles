# PS support base script
# https://stackoverflow.com/a/44810914/8552476

# 1. Catch bugs before run
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-strictmode
Set-StrictMode -Version Latest

# 2. Stop if an error occurs
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables#erroractionpreference
$ErrorActionPreference = 'Stop'

$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

# --------------------- Install-master-script.ps1 ---------------------

$runAsAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if (!$runAsAdmin) {
    Write-Error "Script is not running as admin. Please run with admin priviledges"
    $host.Exit()
}

# import Appx or this wont work
# https://superuser.com/questions/1456837/powershell-get-appxpackage-not-working
if ($PSVersionTable.PSVersion.Major -eq 5) {
    # -UseWindowsPowershell it doesn't work on PS 5.0, only in 7.0
    Import-Module -Name Appx
}
elseif ($PSVersionTable.PSVersion.Major -eq 7) {
    # -UseWindowsPowershell it doesn't work on PS 5.0, only in 7.0
    Import-Module -Name Appx -UseWindowsPowerShell
}
else {
    Write-Error "unknown powershell version"
}

# clear screen
Clear-Host

# make ~/all-repos/ ~/repos/ and ~/other-repos/ folders
Write-Host "`ncreating `\*repos` - " -ForegroundColor Yellow -NoNewline; Write-Host "[1-10]" -ForegroundColor Green -BackgroundColor Black

$reposFolderExists = Test-Path "C:\Users\$env:Username\repos\"
$otherReposFolderExists = Test-Path "C:\Users\$env:Username\other-repos\"

if (!$reposFolderExists) {
    New-Item -ItemType Directory "C:\Users\$env:Username\repos\"
}
else {
    Write-Host "~/repos/ folder found. Skipping`n" -ForegroundColor Yellow
}
if (!$otherReposFolderExists) {
    New-Item -ItemType Directory "C:\Users\$env:Username\other-repos\"
}
else {
    Write-Host "~/other-repos/ folder found. Skipping`n" -ForegroundColor Yellow
}

# scoop install
Write-Host "`nInstalling scoop & apps - "  -ForegroundColor Yellow -NoNewline ; Write-Host "[2-10]" -ForegroundColor Green -BackgroundColor Black
try {
    $scoopIsInstalled = [Boolean](Get-Command 'scoop' -ErrorAction SilentlyContinue)
    if (!$scoopIsInstalled) {
        # Set policy to avoid errors
        Set-ExecutionPolicy RemoteSigned -scope CurrentUser

        # Install scoop
        Invoke-WebRequest -UseBasicParsing get.scoop.sh | Invoke-Expression
    }

    # Scoop can utilize aria2 to use multi-connection downloads
    scoop install aria2
    # disable the warning
    scoop config aria2-warning-enabled false

    # buckets
    # git is required for buckets
    scoop install git
    scoop bucket add extras

    # terminal apps
    scoop install main/bat main/less
    scoop install main/delta
    scoop install main/fd
    scoop install main/fzf
    scoop install main/gh
    scoop install main/glab
    scoop install main/neovim extras/neovide
    scoop install main/nu
    scoop install main/oh-my-posh
    scoop install main/pwsh
    scoop install main/ripgrep
    scoop install main/tokei
    scoop install main/yazi

    # graphical apps
    scoop install extras/czkawka-gui
    scoop install extras/everything
    scoop install extras/firefox
    scoop install extras/googlechrome
    scoop install extras/jpegview-fork
    scoop install extras/keepassxc
    scoop install extras/obs-studio
    scoop install extras/obsidian
    scoop install extras/peazip
    scoop install extras/powertoys
    scoop install extras/signal
    scoop install extras/sumatrapdf
    scoop install extras/vlc
    scoop install extras/vscode
    scoop install extras/windirstat
    # scoop install main/innounp Inno Setup

    # Additional
    # scoop install main/poppler # PDF rendering library
    # scoop install extras/anydesk
    scoop install 7zip
    scoop install extras/autohotkey
    # scoop install clipboard
    scoop install main/difftastic
    # scoop install dbeaver
    # scoop install dust
    # scoop install espanso
    scoop install main/ffmpeg
    # scoop install glow
    # scoop install httrack
    # scoop install mailspring
    scoop install ov
    # scoop install rga main/pandoc
    scoop install sad
    # scoop install scoop-completion
    # scoop install teamviewer
    # scoop install telegram
    scoop install terminal-icons
    scoop install extras/vcredist
    scoop install main/vcpkg
    # scoop install watchexec

    # optional apps
    # scoop install audacity extras/brave calibre digikam extras/gimp tradingview
    # scoop install mongodb mongodb-compass mongosh postgresql sqlite surrealdb
    # scoop install authy calibre gcc nomino

    # programming languages
    scoop install main/deno
    scoop install main/fnm
    scoop install main/bun
    # scoop install main/uv
    # uv python install <error>
    # uv tool install ruff
    # uv tool install isort
    # uv tool install pytest

    # optional langs
    # scoop install flutter dotnet-sdk

    # add rust-analyzer for nvim
    # rustup component add rust-analyzer
}
catch { Write-Warning $_ }

# configure `git
Write-Host "`nconfiguring git" -ForegroundColor Yellow -NoNewline; Write-Host "[3-10]" -ForegroundColor Green -BackgroundColor Black
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
# set `git push` to automatically setup the remote branch (no need to --set-upstream-to=)
# git config --global --add --bool push.autoSetupRemote true

Write-Host "`nInstall diffnav (git diff pager)" -ForegroundColor Yellow -NoNewline; Write-Host "[3-10]" -ForegroundColor Green -BackgroundColor Black
scoop install main/go
go install github.com/dlvhdr/diffnav@latest

# clone `dotfiles`
Write-Host "`ncloning `\dotfiles\` - " -ForegroundColor Yellow -NoNewline; Write-Host "[4-10]" -ForegroundColor Green -BackgroundColor Black

$dotfilesFolderExists = Test-Path "C:\Users\$env:Username\repos\dotfiles\"

if (!$dotfilesFolderExists) {
    git clone https://github.com/AucaCoyan/dotfiles "$HOME\repos\dotfiles"
}
else {
    Write-Host "~/repos/dotfiles/ folder found. Skipping`n" -ForegroundColor Yellow
    # Write-Error "~\repos\dotfiles\ folder exists. Stopping excecution.`n"
}

# hardlink the .gitconfig
Write-Host "`nSymlinking `~\.gitconfig` - " -ForegroundColor Yellow -NoNewline; Write-Host "[5-10]" -ForegroundColor Green -BackgroundColor Black

$dotgitconfigExists = Test-Path "C:\Users\$env:Username\.gitconfig"

if (!$dotgitconfigExists) {
    New-Item -Type HardLink -path ~/.gitconfig -Target ~\repos\dotfiles\.gitconfig
}
else {
    Write-Host "~/.gitconfig found. Renaming to gitconfig.bak...`n" -ForegroundColor Yellow
    Rename-Item -Path ~/.gitconfig -NewName gitconfig.bak
    Write-Host "Creating Symlink" -ForegroundColor Yellow
    New-Item -Type HardLink -path ~/.gitconfig -Target ~\repos\dotfiles\.gitconfig
    # Write-Error "~\repos\dotfiles\ folder exists. Stopping excecution.`n"
}

# Install glyphed fonts
$Font = "FiraCode"
Write-Host "`nInstalling glyphed fonts for OMP [$Font] - " -ForegroundColor Yellow -NoNewline ; Write-Host "[6-10]" -ForegroundColor Green -BackgroundColor Black
try {
    $fontsToInstallDirectory = "$Font-temp"

    # clean the folder if the font or directory exists
    $zipFileExists = Test-Path ".\$Font.zip"
    $fontsToInstallDirectoryExists = Test-Path "$fontsToInstallDirectory\"

    if ($zipFileExists) {
        Write-Host "$Font.zip found! Removing..." -ForegroundColor Yellow
        Remove-Item "$Font.zip"
    }
    if ($fontsToInstallDirectoryExists) {
        Write-Host "$fontsToInstallDirectory dir found! Removing..." -ForegroundColor Yellow
        Remove-Item "$fontsToInstallDirectory\" -Recurse -Force
    }

    # download the font
    # it doesnt work with .tar.xz. Only with .zip
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$Font.zip" -OutFile "./$Font.zip"

    # expand the zip
    # (you don't need to create the directory)
    Expand-Archive ".\$Font.zip" -DestinationPath $fontsToInstallDirectory


    # install the fonts
    $fontsToInstall = Get-ChildItem $fontsToInstallDirectory -Recurse -Include '*.ttf'

    $shellObejct = New-Object -ComObject shell.application
    $Fonts = $shellObejct.NameSpace(0x14)

    foreach ($f in $fontsToInstall) {
        $fullPath = $f.FullName
        $name = $f.Name
        $userInstalledFonts = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
        if (!(Test-Path "$UserInstalledFonts\$Name")) {
            Write-Host "Installing $name... " -ForegroundColor Green
            $Fonts.CopyHere($FullPath)
        }
        else {
            $name = $f.Name
            Write-Host "$name found!. Skipping" -ForegroundColor Yellow
        }
    }
    Write-Host "Finished! $name... " -ForegroundColor Green

    Write-Host "Removing $Font.zip" -ForegroundColor Yellow
    Remove-Item "$Font.zip"
    Write-Host "Removing $fontsToInstallDirectory\ dir" -ForegroundColor Yellow
    Remove-Item "$fontsToInstallDirectory\" -Recurse -Force
}
catch { Write-Warning $_ }

# Set PS profile
# Write-Host "`nApplying Powershell profile - " -ForegroundColor Yellow -NoNewline ; Write-Host "[8-10]" -ForegroundColor Green -BackgroundColor Black
# try {
    # backup
    # if (Test-Path $profile) { Rename-Item $profile -NewName Microsoft.PowerShell_profile.ps1.bak }

    # $originPath = "$HOME\OneDrive\Documents\PowerShell\"
    # $destinationPath = "$HOME\repos\dotfiles\Windows\PowerShell"

    # delete the folder if it exists
    # $LocalStateExits = Test-Path $originPath
    # if ($LocalStateExits) {
    #     Remove-Item $originPath -Recurse -Force
    # }

    # symlink the settings.json
    # New-Item -ItemType SymbolicLink -Path $originPath -Target $destinationPath
# }
# catch { Write-Warning $_ }

# todo:
# pipx
# cargo install
# npm -g install

# Set nushell symlink
Write-Host "`nApplying nushell settings - " -ForegroundColor Yellow -NoNewline ; Write-Host "[10-10]" -ForegroundColor Green -BackgroundColor Black
try {
    $originPath = "$HOME\AppData\Roaming\nushell"
    $destinationPath = "$HOME\repos\dotfiles\nushell"

    # delete the folder if it exists
    $LocalStateExits = Test-Path $originPath
    if ($LocalStateExits) {
        Remove-Item $originPath -Recurse -Force
    }

    # symlink the settings.json
    New-Item -ItemType SymbolicLink -Path $originPath -Target $destinationPath
}
catch { Write-Warning $_ }

# clone nu_scripts
Write-Host "`ncloning `\nu_scripts\` - " -ForegroundColor Yellow -NoNewline; Write-Host "[4-10]" -ForegroundColor Green -BackgroundColor Black

$nu_scriptsFolderExists = Test-Path "C:\Users\$env:Username\other-repos\nu\nu_scripts"
$nupmFolderExists = Test-Path "C:\Users\$env:Username\other-repos\nu\nupm"

if (!$nu_scriptsFolderExists) {
    git clone https://github.com/nushell/nu_scripts "$HOME\other-repos\nu\nu_scripts"
}
else {
    Write-Host "~/other-repos/nu/nu_scripts/ folder found. Skipping`n" -ForegroundColor Yellow
    # Write-Error "~\other-repos\nu\nu_scripts\ folder exists. Stopping excecution.`n"
}

# Install node and npm
Write-Host "`nInstalling node with fnm - " -ForegroundColor Yellow -NoNewline ; Write-Host "[11-11]" -ForegroundColor Green -BackgroundColor Black
fnm install --latest
