# PS support base script
# https://stackoverflow.com/a/44810914/8552476

# 1. Catch bugs before run
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-strictmode
Set-StrictMode -Version Latest

# 2. Stop if an error occurs
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables#erroractionpreference
$ErrorActionPreference = 'Stop'

$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'
function ThrowOnNativeFailure {
    if (-not $?) {
        throw 'Native Failure'
    }
}