
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\scripts\ps_support.ps1"

# import Appx or this wont work
# https://superuser.com/questions/1456837/powershell-get-appxpackage-not-working
Import-Module -Name Appx -UseWindowsPowershell


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
    winget install --id Microsoft.Powershell --source winget --accept-package-agreements --accept-source-agreements
}
else {
    Write-Host "pwsh.exe found. Skipping`n" -ForegroundColor Yellow
}


# Install Windows Terminal
Write-Host "`nInstalling Windows Terminal - " -ForegroundColor Yellow -NoNewline ; Write-Host "[3-10]" -ForegroundColor Green -BackgroundColor Black
$hasWindowsTerminal = Get-AppPackage -Name "Microsoft.WindowsTerminal"
try {
    if (!$env:WT_SESSION -eq $true -or !$hasWindowsTerminal) {
        winget install --id=Microsoft.WindowsTerminal -e --accept-package-agreements --accept-source-agreements
    }
    else {
        Write-Host "Windows Terminal found. Skipping`n" -ForegroundColor Yellow

    }
}
catch { Write-Warning $_ }

# Install glyphed fonts
Write-Host "`nInstalling glyphed fonts for OMP [Caskaydia Cove Nerd] - " -ForegroundColor Yellow -NoNewline ; Write-Host "[4-10]" -ForegroundColor Green -BackgroundColor Black
try {
    $shellObject = New-Object -ComObject shell.application
    $fonts = $ShellObject.NameSpace(0x14)
    $fontsToInstallDirectory = ".\fonts\*.ttf"
    $fontsToInstall = Get-ChildItem $fontsToInstallDirectory -Recurse -Include '*.ttf'
    foreach ($f in $fontsToInstall) {
        $fullPath = $f.FullName
        $name = $f.Name
        $userInstalledFonts = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts"
        if (!(Test-Path "$UserInstalledFonts\$Name")) {
            $Fonts.CopyHere($FullPath)
        }
        else {
            Write-Host "$f found!. Skipping`n" -ForegroundColor Yellow
        }
    }
}
catch { Write-Warning $_ }


# Set PSGallery as trusted
Write-Host "`nSetting PSGallery as trusted repo - " -ForegroundColor Yellow -NoNewline ; Write-Host "[4-10]" -ForegroundColor Green -BackgroundColor Black
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# scoop install
Write-Host "`nInstalling scoop & apps - "  -ForegroundColor Yellow -NoNewline ; Write-Host "[5-10]" -ForegroundColor Green -BackgroundColor Black
try {
    $scoopIsInstalled = [Boolean](Get-Command 'scoop' -ErrorAction SilentlyContinue)
    if (!$scoopIsInstalled) {
        # Set policy to avoid errors
        Set-ExecutionPolicy RemoteSigned -scope CurrentUser

        # Install scoop
        Invoke-WebRequest -UseBasicParsing get.scoop.sh | Invoke-Expression
    }
    # install apps
    .\scripts\scoop.ps1
    throw exepcion

    $dest = "C:\Users\$env:Username\AppData\Local\Programs\oh-my-posh\themes"
    if (!(Test-Path -Path $dest)) { New-Item $dest -Type Directory }
    Copy-Item ".\src\wylde.omp.json" -Destination $dest
}
catch { Write-Warning $_ }

# Install ps modules in PS7
Write-Host "`nInstalling Z,PsReadLine,Terminal-Icons, man-highlighting modules - "  -ForegroundColor Yellow -NoNewline ; Write-Host "[9-10]" -ForegroundColor Green -BackgroundColor Black

if ($PSVersionTable.PSVersion.Major -eq 7) {
    try {
        Install-Module -Name z -RequiredVersion 1.1.3 -Force -Scope CurrentUser -AllowClobber -confirm:$false
        Install-Module -Name Terminal-Icons -RequiredVersion 0.8.0 -Force -Scope CurrentUser -confirm:$false
        Install-Module -Name PSReadLine -RequiredVersion 2.2.6 -Force -AllowPrerelease -Scope CurrentUser -SkipPublisherCheck
        Install-Module -Name man-highlighting 
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
try {
    $dest2 = "C:\Users\$env:Username\Documents\PowerShell"
    [System.IO.Directory]::CreateDirectory($dest2) > $null
    Copy-Item ".\src\Microsoft.PowerShell_profile.ps1" -Destination $dest2 -Force
}
catch { Write-Warning $_ }


# Set WT settings.json
Write-Host "`nApplying Windows Terminal default settings - " -ForegroundColor Yellow -NoNewline ; Write-Host "[10-10]" -ForegroundColor Green -BackgroundColor Black
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

# Wrap up time for PS7 module install jobs
[int]$time = 30
$length = $time / 100
for ($time; $time -gt 0; $time--) {
    $min = [int](([string]($time / 60)).split('.')[0])
    $text = " " + $min + " minutes " + ($time % 60) + " seconds left."
    Write-Progress -Activity "Finishing up PS7 module installs in background job" -Status $text -PercentComplete ($time / $length)
    Start-Sleep 1
}

# Oh-My-Posh install, add to default prompt, add theme