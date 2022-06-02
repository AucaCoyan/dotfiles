# How to config Powershell in windows

- Install `Windows Terminal` from Windows App Store
- Install `chocolatey`
- Copy `Microsoft.PowerShell_profile.ps1` into `echo $PROFILE`

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
