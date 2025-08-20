# Installation via script

Allow to run external sripts

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

run this script

```powershell
$InstallMasterScriptURI = "https://raw.githubusercontent.com/AucaCoyan/dotfiles/main/Windows/Install-master-script.ps1"
Invoke-WebRequest -Uri $InstallMasterScriptURI -OutFile .\Install-master-script.ps1
```

and run it with

```powershell
& .\Install-master-script.ps1
```

## Follow up

After the installation you do the normal stuff:

- adjust the monitors order
- change the wallpaper
- configure the taskbar
- set default apps like browser, img viewer, pdf viewer and so on.

And probably you'll need some symlinks

```powershell
# Delete the contents first
rm $HOME\Downloads -Recurse -Force
# and create the symlink
New-Item -ItemType SymbolicLink -Path $HOME\Downloads -Target $HOME\OneDrive\Downloads\
```

## How to check your installed packages

For `scoop` you can run

```sh
scoop list
```

And for PowerShell Modules, run:

```sh
Get-InstalledModule
```

and from `winget`

```sh
# to get an infinite list of packages
winget list

# to export the actually installed
winget export -o packages.json
```

## Symlinks

Run this to link wezterm config

```powershell
 New-Item -ItemType SymbolicLink -path ~/.wezterm.lua -Target C:\Users\aucac\repos\dotfiles\.config\wezterm\.wezterm.lua
```

Link your Proton notes and *.kdbx
```powershell
New-Item -ItemType SymbolicLink -path 'C:\Users\aucac\OneDrive\notes' -Target 'C:\Users\aucac\Proton Drive\aucacoyan\My files\notes'
New-Item -ItemType SymbolicLink -path 'C:\Users\aucac\OneDrive\Pass brataia.kdbx' -Target 'C:\Users\aucac\Proton Drive\aucacoyan\My files\Pass brataia.kdbx'

```
