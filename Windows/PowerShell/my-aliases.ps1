# Alias File
# Exported by : aucac
#
# Remember to remove any "ReadOnly" alias with:
# :%s/.*ReadOnly*\n//gc
# and delete empty lines with
# :%s/^\n//gc

set-alias -Name:"cd" -Value:"Set-LocationWithFnm" -Description:"" -Option:"AllScope"
set-alias -Name:"dir" -Value:"Get-ChildItem" -Description:"" -Option:"AllScope"
set-alias -Name:"echo" -Value:"Write-Output" -Description:"" -Option:"AllScope"
set-alias -Name:"md" -Value:"mkdir" -Description:"" -Option:"AllScope"
set-alias -Name:"popd" -Value:"Pop-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"pushd" -Value:"Push-Location" -Description:"" -Option:"AllScope"
set-alias -Name:"copy" -Value:"Copy-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"del" -Value:"Remove-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"move" -Value:"Move-Item" -Description:"" -Option:"AllScope"
set-alias -Name:"sls" -Value:"Select-String" -Description:"" -Option:"None"
set-alias -Name:"fhx" -Value:"Format-Hex" -Description:"" -Option:"None"
set-alias -Name:"gcb" -Value:"Get-Clipboard" -Description:"" -Option:"None"
set-alias -Name:"gin" -Value:"Get-ComputerInfo" -Description:"" -Option:"None"
set-alias -Name:"gtz" -Value:"Get-TimeZone" -Description:"" -Option:"None"
set-alias -Name:"scb" -Value:"Set-Clipboard" -Description:"" -Option:"None"
set-alias -Name:"stz" -Value:"Set-TimeZone" -Description:"" -Option:"None"
set-alias -Name:"refreshenv" -Value:"Update-SessionEnvironment" -Description:"" -Option:"None"
set-alias -Name:"cd_with_fnm" -Value:"Set-LocationWithFnm" -Description:"" -Option:"None"
set-alias -Name:"git log" -Value:"git log --graph --pretty=format:'%C(bold red)%an%C(reset) - %C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white) %C(bold cyan)%d%C(reset)'" -Description:"" -Option:"None"
set-alias -Name:"touch" -Value:"New-Item" -Description:"" -Option:"None"
