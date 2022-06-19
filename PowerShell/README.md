# How to config Powershell in windows

- Install `Windows Terminal` from Windows App Store
- Update [Powershell to the latest version](https://stackoverflow.com/questions/60524714/update-powershell-to-the-latest-revision)

  > winget install Microsoft.PowerShell

- Install `chocolatey`
- Copy `Microsoft.PowerShell_profile.ps1` into `echo $PROFILE`
- install [Caskaydia Cove NF for windows](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CascadiaCode/Regular/complete)
- Go to Windows Terminal Settings / Windows Powershell / Appearece / Font face = `CaskaydiaCove NF`
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

## Windows Terminal config

[`settings.json` location](https://stackoverflow.com/a/67400504/8552476)

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

## Extra! - Install all the packages of chocolatey

bat
dart-sdk
fd
gh
less
neovim
ripgrep
ripgrepall
sass

## possible errors

    oh-my-posh : The term 'oh-my-posh' is not recognized as the name of a cmdlet, function, script file, or operable
    program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
    At C:\Users\aucac\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1:2 char:1
    + oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | I ...
    + ~~~~~~~~~~
        + CategoryInfo          : ObjectNotFound: (oh-my-posh:String) [], CommandNotFoundException
        + FullyQualifiedErrorId : CommandNotFoundException

    Import-Module : The specified module 'Terminal-Icons' was not loaded because no valid module file was found in any
    module directory.
    At C:\Users\aucac\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1:17 char:1
    + Import-Module -Name Terminal-Icons
    + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : ResourceUnavailable: (Terminal-Icons:String) [Import-Module], FileNotFoundException
        + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand

    Set-PSReadLineOption : A parameter cannot be found that matches parameter name 'PredictionSource'.
    At C:\Users\aucac\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1:21 char:22
    + Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    +                      ~~~~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidArgument: (:) [Set-PSReadLineOption], ParameterBindingException
        + FullyQualifiedErrorId : NamedParameterNotFound,Microsoft.PowerShell.SetPSReadLineOption

    Set-PSReadLineOption : A parameter cannot be found that matches parameter name 'PredictionViewStyle'.
    At C:\Users\aucac\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1:22 char:22
    + Set-PSReadLineOption -PredictionViewStyle ListView
    +                      ~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidArgument: (:) [Set-PSReadLineOption], ParameterBindingException
        + FullyQualifiedErrorId : NamedParameterNotFound,Microsoft.PowerShell.SetPSReadLineOption`
