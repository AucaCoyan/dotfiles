# How to config Powershell in windows

- Install `Windows Terminal` from Windows App Store

- Update [Powershell to the latest version](https://stackoverflow.com/questions/60524714/update-powershell-to-the-latest-revision)

```powershell
winget install Microsoft.PowerShell
```

⚠️ make sure you select the new `PowerShell` as the default shell!. It has a black icon

- Make a `Junction` from this `PowerShell` folder into `echo $PROFILE`
- install [Caskaydia Cove NF for windows](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CascadiaCode/Regular/complete)
- Go to Windows Terminal Settings / Windows Powershell / Appearence / Font face = `CaskaydiaCove NF`

- Install a package manager (`scoop`, `chocolatey` or `winget`)

# Option A: `scoop`

I find scoop easy to use, because it install portable apps from the command line. This way the registry it's less modified and cluttered, so in the end you have less install pollution.

Install `scoop` with:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

Then, you can import the packages in `scoop-list.json` found in this folder.

# Option B: `chocolatey`

Chocolatey is the first package manager made for windows. It has wide support for a lot of applications.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

For upgrading run

```
choco upgrade chocolatey
```

You can also import and install the packages on the `packages.config` file with `choco install packages.config`

# used modules

Below you will find the modules I use most of the time.

| package     | description                                           |
| ----------- | ----------------------------------------------------- |
| bat         | better `cat` in rust                                  |
| dart-sdk    | dart language                                         |
| delta       | `git diff` made right in rust                         |
| deno        | A modern runtime for JavaScript and TypeScript        |
| fd          | better `fd` in rust                                   |
| fnm         | fast NodeJS Manager in rust                           |
| gh          | github CLI                                            |
| git         | `--distributed-even-if-your-workflow-isnt`            |
| gitui       | CLI UI interface                                      |
| glow        | Render markdown on the CLI, with pizzazz! 💅🏻          |
| less        | less is more                                          |
| neovim      | Vim-fork focused on extensibility and usability       |
| pnpm        | A fast and disk space efficient Node package manager. |
| pyenv-win   | a simple python version management tool               |
| ripgrep     | better `grep` in rust                                 |
| ripgrep-all | better `ripgrep` in rust                              |
| sass        | official `sass` library                               |

# `npm` modules

| module      | description                                                             |
| ----------- | ----------------------------------------------------------------------- |
| gitmoji-cli | A gitmoji interactive command line tool for using emojis on commits. 💻 |
| pnpm        | _It is installed with scoop_                                            |

# Modules by PowerShell:

| Version | Name           | Repository | Description                                                                                                                       |
| ------- | -------------- | ---------- | --------------------------------------------------------------------------------------------------------------------------------- |
| 7.62.0  | oh-my-posh     | PSGallery  | A prompt theme engine for any shell                                                                                               |
| 2.4.0   | PSFzf          | PSGallery  | A thin wrapper around Fzf (https://github.com/junegunn/fzf). If PSReadline is loaded, this wrapper registers Fzf with the keyboa… |
| 2.2.2   | PSReadLine     | PSGallery  | Great command line editing in the PowerShell console host                                                                         |
| 0.9.0   | Terminal-Icons | PSGallery  | PowerShell module to add file icons to terminal based on file extension                                                           |

- Install [`oh-my-posh`](https://ohmyposh.dev/docs/installation/windows)

  > winget install oh-my-posh

- Copy `jandedobbeleer.omp.json` into `~/jandedobbeleer.omp.json`

  > cd ~/Code/dotfiles/Powershell/
  > cp jandedobbeler.omp.json ~/

- Install `TerminalIcons`

https://github.com/devblackops/Terminal-Icons

> Install-Module -Name Terminal-Icons -Repository PSGallery

- If you didn't upgrade Powershell, PSReadLineOption won't be available
  > Set-PSReadLineOption : The prediction plugin source is not supported in this version of PowerShell. The 7.2 or a higher version of PowerShell is required to use this source.

upgrade it via

> winget install Microsoft.PowerShell

## Check your installed packages

For `chocolatey` you can run

```sh
choco list --local-only
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

## Windows Terminal config

Stackoverflow on [`settings.json` location](https://stackoverflow.com/a/67400504/8552476)

- For configuring the same nerd font for all profiles:

```json
{
  "profiles": {
    "defaults": {
      "font": {
        "face": "MesloLGM NF"
      }
    }
  }
}
```

[see here](https://ohmyposh.dev/docs/configuration/fonts)

## Nice to have symlinks

You can learn what symlinks are [with this Thio Joe video](https://www.youtube.com/watch?v=RDH5IuyPJtk).

Some nice to have symlinks:

- `~\.gitconfig  ~\repos\dotfiles\.gitconfig`

- `~\Downloads  ~\OneDrive\Downloads`

## Extra! - Install all the packages of chocolatey

There are some other pkgs that you could install with choco, like:

- git-lfs
- nodejs.install (18)
- nodejs-lts (16.15.1)
- vscode
- sumatrapdf.install
- microsoft-windows-terminal
- slack
- spotify
- virtualbox
- golang
- postman (or whatever)
- autohotkey.install
- everything
- calibre
- windirstat
- qbittorrent
- whatsapp
- telegram.install
- poshgit
- discord.install
- obs-studio.install
- keepassxc
- steam-client
- eartrumpet

## possible errors

#### oh-my-posh

if you have this error:

```
oh-my-posh : The term 'oh-my-posh' is not recognized as the name of a cmdlet, function, script file, or operable
program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
At C:\Users\aucac\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1:2 char:1
+ oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | I ...
+ ~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (oh-my-posh:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
```

you need to install `oh my posh`

#### Terminal-Icons

Same here, if you have this error:

    Import-Module : The specified module 'Terminal-Icons' was not loaded because no valid module file was found in any
    module directory.
    At C:\Users\aucac\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1:17 char:1
    + Import-Module -Name Terminal-Icons
    + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : ResourceUnavailable: (Terminal-Icons:String) [Import-Module], FileNotFoundException
        + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand

you need to install `terminal-icons`
