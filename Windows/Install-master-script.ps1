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

# Check for winget and install
Write-Host "`nInstalling winget - " -ForegroundColor Yellow -NoNewline; Write-Host "[1-10]" -ForegroundColor Green -BackgroundColor Black
$hasPackageManager = Get-AppPackage -name "Microsoft.DesktopAppInstaller"
$hasWingetexe = Test-Path "C:\Users\$env:Username\AppData\Local\Microsoft\WindowsApps\winget.exe"
if (!$hasPackageManager -or !$hasWingetexe) {
    $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri "$($releases_url)"
    $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1
    Add-AppxPackage -Path $latestRelease.browser_download_url
}
else {
    Write-Host "Winget found. Skipping`n" -ForegroundColor Yellow
}

# Install PS7 
Write-Host "Installing Powershell 7 - " -ForegroundColor Yellow -NoNewline; Write-Host "[2-10]" -ForegroundColor Green -BackgroundColor Black
If (!(Test-Path "C:\Program Files\PowerShell\7\pwsh.exe")) {
    winget install --id Microsoft.Powershell --source winget #  --accept-package-agreements --accept-source-agreements doesnt work on PS 5.0
}
else {
    Write-Host "pwsh.exe found. Skipping`n" -ForegroundColor Yellow
}


# Install Windows Terminal
# Write-Host "`nInstalling Windows Terminal - " -ForegroundColor Yellow -NoNewline ; Write-Host "[3-10]" -ForegroundColor Green -BackgroundColor Black
# $hasWindowsTerminal = Get-AppPackage -Name "Microsoft.WindowsTerminal"
# try {
#     if (!$env:WT_SESSION -eq $true -or !$hasWindowsTerminal) {
#         winget install --id=Microsoft.WindowsTerminal -e # --accept-package-agreements --accept-source-agreements doesnt work on PS 5.0
#     }
#    else {
#       Write-Host "Windows Terminal found. Skipping`n" -ForegroundColor Yellow
#    }
#}
#catch { Write-Warning $_ }

# make ~/all-repos/ ~/repos/ and ~/other-repos/ folders
Write-Host "`ncreating `\*repos` - " -ForegroundColor Yellow -NoNewline; Write-Host "[4-10]" -ForegroundColor Green -BackgroundColor Black

$allReposFolderExists = Test-Path "C:\Users\$env:Username\all-repos\"
$reposFolderExists = Test-Path "C:\Users\$env:Username\repos\"
$otherReposFolderExists = Test-Path "C:\Users\$env:Username\other-repos\"

if (!$allReposFolderExists) {
    New-Item -ItemType Directory "C:\Users\$env:Username\all-repos\"
}
else {
    Write-Host "~/all-repos/ folder found. Skipping`n" -ForegroundColor Yellow
}
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
Write-Host "`nInstalling scoop & apps - "  -ForegroundColor Yellow -NoNewline ; Write-Host "[6-10]" -ForegroundColor Green -BackgroundColor Black
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

    # core
    scoop install 7zip autohotkey bat
    scoop install broot delta difftastic draw.io 
    scoop install dust everything fd ffmpeg fzf gh git gitui glab glow googlechrome jpegview-fork
    scoop install keepassxc neovide neovim
    scoop install nu obsidian oh-my-posh obs-studio peazip postman powertoys psreadline rga 
    scoop install ripgrep rustdesk scoop-completion sublime-merge sumatrapdf teamviewer 
    scoop install telegram terminal-icons tokei vcpkg vcredist2022 vlc vscode windirstat windows-terminal zoxide

    # optional apps
    # scoop install audacity azuredatastudio calibre discord gcc insomnia mongodb mongodb-compass mongosh nomino

    # programming languages
    scoop install deno fnm python rustup
    # optional langs
    # scoop install flutter surrealdb

    # local github actions runner
    scoop install main/act

    # add rust-analyzer for nvim
    rustup component add rust-analyzer
}
catch { Write-Warning $_ }

# clone `dotfiles`
Write-Host "`ncloning `\dotfiles\` - " -ForegroundColor Yellow -NoNewline; Write-Host "[4-10]" -ForegroundColor Green -BackgroundColor Black

$dotfilesFolderExists = Test-Path "C:\Users\$env:Username\repos\dotfiles\"

if (!$dotfilesFolderExists) {
    git clone https://github.com/AucaCoyan/dotfiles "$HOME\repos\dotfiles"
}
else {
    Write-Error "~\repos\dotfiles\ folder exists. Stopping excecution.`n" 
}

# Install glyphed fonts
$Font = "FiraCode"
Write-Host "`nInstalling glyphed fonts for OMP [$Font] - " -ForegroundColor Yellow -NoNewline ; Write-Host "[4-10]" -ForegroundColor Green -BackgroundColor Black
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

# Install NuGet
# it doesn't work either :shrug:
Write-Host "`nInstalling NuGet" -ForegroundColor Yellow -NoNewline ; Write-Host "[5-10]" -ForegroundColor Green -BackgroundColor Black
scoop install nuget

# Set PSGallery as trusted
Write-Host "`nSetting PSGallery as trusted repo - " -ForegroundColor Yellow -NoNewline ; Write-Host "[5-10]" -ForegroundColor Green -BackgroundColor Black
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install ps modules in PS7
Write-Host "`nInstalling Z,PsReadLine,Terminal-Icons modules - "  -ForegroundColor Yellow -NoNewline ; Write-Host "[7-10]" -ForegroundColor Green -BackgroundColor Black

if ($PSVersionTable.PSVersion.Major -eq 7) {
    try {
        Install-Module -Name z -RequiredVersion 1.1.3 -Force -Scope CurrentUser -AllowClobber -confirm:$false
        Install-Module -Name Terminal-Icons -RequiredVersion 0.8.0 -Force -Scope CurrentUser -confirm:$false
        Install-Module -Name PSReadLine -RequiredVersion 2.2.6 -Force -AllowPrerelease -Scope CurrentUser -SkipPublisherCheck
    }
    catch { Write-Warning $_ }
}
else {
    <#     try {
        Start-Job -ScriptBlock {
            Start-Process "C:\Program Files\PowerShell\7\pwsh.exe" -ArgumentList { -Command Install-Module -Name z -RequiredVersion 1.1.3 -Force -Scope CurrentUser -AllowClobber -confirm:$false } -NoNewWindow
            Start-Process "C:\Program Files\PowerShell\7\pwsh.exe" -ArgumentList { -Command Install-Module -Name Terminal-Icons -RequiredVersion 0.8.0 -Force -Scope CurrentUser -confirm:$false } -NoNewWindow
            Start-Process "C:\Program Files\PowerShell\7\pwsh.exe" -ArgumentList { -Command Install-Module -Name PSReadLine -RequiredVersion 2.2.6 -Force -AllowPrerelease -Scope CurrentUser -SkipPublisherCheck } -NoNewWindow
        } | Wait-Job | Receive-Job
    }
    catch { Write-Warning $_ } #>
}

# Set PS profile
Write-Host "`nApplying Powershell profile - " -ForegroundColor Yellow -NoNewline ; Write-Host "[8-10]" -ForegroundColor Green -BackgroundColor Black
try {
    # backup
    # if (Test-Path $profile) { Rename-Item $profile -NewName Microsoft.PowerShell_profile.ps1.bak }

    $originPath = "$HOME\OneDrive\Documents\PowerShell\"
    $destinationPath = "$HOME\repos\dotfiles\Windows\PowerShell"

    # delete the folder if it exists
    $LocalStateExits = Test-Path $originPath
    if ($LocalStateExits) {
        Remove-Item $originPath -Recurse -Force
    }

    # symlink the settings.json
    New-Item -ItemType Junction -Path $originPath -Target $destinationPath
}
catch { Write-Warning $_ }

# Set WT settings.json
Write-Host "`nApplying Windows Terminal default settings - " -ForegroundColor Yellow -NoNewline ; Write-Host "[9-10]" -ForegroundColor Green -BackgroundColor Black
try {
    $originPath = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    $destinationPath = "$HOME\repos\dotfiles\Windows\windows-terminal"

    # delete the folder if it exists
    $LocalStateExits = Test-Path $originPath
    if ($LocalStateExits) {
        Remove-Item $originPath -Recurse -Force
    }

    # symlink the settings.json
    New-Item -ItemType Junction -Path $originPath -Target $destinationPath
}
catch { Write-Warning $_ }

# todo:
# Oh-My-Posh install, add to default prompt, add theme
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
    New-Item -ItemType Junction -Path $originPath -Target $destinationPath
}
catch { Write-Warning $_ }

# Set bat symlink
Write-Host "`nApplying bat settings - " -ForegroundColor Yellow -NoNewline ; Write-Host "[11-11]" -ForegroundColor Green -BackgroundColor Black
try {
    $originPath = "$HOME\AppData\Roaming\bat"
    $destinationPath = "$HOME\repos\.config\bat"

    # delete the folder if it exists
    $LocalStateExits = Test-Path $originPath
    if ($LocalStateExits) {
        Remove-Item $originPath -Recurse -Force
    }

    # symlink the settings.json
    New-Item -ItemType Junction -Path $originPath -Target $destinationPath
}
catch { Write-Warning $_ }
