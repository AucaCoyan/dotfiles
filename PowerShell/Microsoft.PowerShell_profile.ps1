# imports for `deno` autocompletion
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# Import the Chocolatey Profile that contains the necessary code to enable
oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression
# tab-completions to function for `choco`.
# Be aware that if you are missing these line from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
# Install-Module ZLocation -Scope CurrentUser; Import-Module ZLocation; Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts
# Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"

# Terminal icons and colors for ls
Import-Module -Name Terminal-Icons

# Predictive intellisense
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
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


# colored man-pages
Import-Module man-highlighting

# `fnm`:
# load the `.node-version` or `.nvmrc` file on cd and load the NodeJS version correctly
fnm env --use-on-cd | Out-String | Invoke-Expression
# more on `fnm` autocompletion below!

# -------------------------------------------------------------------------------------
# deno autocompletion
Register-ArgumentCompleter -Native -CommandName 'deno' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'deno'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
            }
            $element.Value
        }) -join ';'

    $completions = @(switch ($command) {
            'deno' {
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Print version information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('bench', 'bench', [CompletionResultType]::ParameterValue, 'Run benchmarks')
                [CompletionResult]::new('bundle', 'bundle', [CompletionResultType]::ParameterValue, 'Bundle module and dependencies into single file')
                [CompletionResult]::new('cache', 'cache', [CompletionResultType]::ParameterValue, 'Cache the dependencies')
                [CompletionResult]::new('check', 'check', [CompletionResultType]::ParameterValue, 'Type-check the dependencies')
                [CompletionResult]::new('compile', 'compile', [CompletionResultType]::ParameterValue, 'UNSTABLE: Compile the script into a self contained executable')
                [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate shell completions')
                [CompletionResult]::new('coverage', 'coverage', [CompletionResultType]::ParameterValue, 'Print coverage reports')
                [CompletionResult]::new('doc', 'doc', [CompletionResultType]::ParameterValue, 'Show documentation for a module')
                [CompletionResult]::new('eval', 'eval', [CompletionResultType]::ParameterValue, 'Eval script')
                [CompletionResult]::new('fmt', 'fmt', [CompletionResultType]::ParameterValue, 'Format source files')
                [CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'Initialize a new project')
                [CompletionResult]::new('info', 'info', [CompletionResultType]::ParameterValue, 'Show info about cache or info related to source file')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Install script as an executable')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall a script previously installed with deno install')
                [CompletionResult]::new('lsp', 'lsp', [CompletionResultType]::ParameterValue, 'Start the language server')
                [CompletionResult]::new('lint', 'lint', [CompletionResultType]::ParameterValue, 'Lint source files')
                [CompletionResult]::new('repl', 'repl', [CompletionResultType]::ParameterValue, 'Read Eval Print Loop')
                [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a JavaScript or TypeScript program')
                [CompletionResult]::new('task', 'task', [CompletionResultType]::ParameterValue, 'Run a task defined in the configuration file')
                [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'Run tests')
                [CompletionResult]::new('types', 'types', [CompletionResultType]::ParameterValue, 'Print runtime TypeScript declarations')
                [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrade deno executable to given version')
                [CompletionResult]::new('vendor', 'vendor', [CompletionResultType]::ParameterValue, 'Vendor remote modules into a local directory')
                [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
                break
            }
            'deno;bench' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
                [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
                [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
                [CompletionResult]::new('--unsafely-ignore-certificate-errors', 'unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
                [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
                [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
                [CompletionResult]::new('--allow-ffi', 'allow-ffi', [CompletionResultType]::ParameterName, 'Allow loading dynamic libraries')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Value of ''globalThis.location'' used by some web APIs')
                [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options')
                [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
                [CompletionResult]::new('--ignore', 'ignore', [CompletionResultType]::ParameterName, 'Ignore files')
                [CompletionResult]::new('--filter', 'filter', [CompletionResultType]::ParameterName, 'Run benchmarks with this string or pattern in the bench name')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
                [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--prompt', 'prompt', [CompletionResultType]::ParameterName, 'deprecated: Fallback to prompt if required permission wasn''t passed')
                [CompletionResult]::new('--no-prompt', 'no-prompt', [CompletionResultType]::ParameterName, 'Always throw if required permission wasn''t passed')
                [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
                [CompletionResult]::new('--enable-testing-features-do-not-use', 'enable-testing-features-do-not-use', [CompletionResultType]::ParameterName, 'INTERNAL: Enable internal features used during integration testing')
                [CompletionResult]::new('--watch', 'watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart automatically')
                [CompletionResult]::new('--no-clear-screen', 'no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;bundle' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--watch', 'watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart automatically')
                [CompletionResult]::new('--no-clear-screen', 'no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;cache' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;check' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--remote', 'remote', [CompletionResultType]::ParameterName, 'Type-check all modules, including remote')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;compile' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
                [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
                [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
                [CompletionResult]::new('--unsafely-ignore-certificate-errors', 'unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
                [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
                [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
                [CompletionResult]::new('--allow-ffi', 'allow-ffi', [CompletionResultType]::ParameterName, 'Allow loading dynamic libraries')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Value of ''globalThis.location'' used by some web APIs')
                [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options')
                [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
                [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterName, 'Output file (defaults to $PWD/<inferred-name>)')
                [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'Output file (defaults to $PWD/<inferred-name>)')
                [CompletionResult]::new('--target', 'target', [CompletionResultType]::ParameterName, 'Target OS architecture')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
                [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--prompt', 'prompt', [CompletionResultType]::ParameterName, 'deprecated: Fallback to prompt if required permission wasn''t passed')
                [CompletionResult]::new('--no-prompt', 'no-prompt', [CompletionResultType]::ParameterName, 'Always throw if required permission wasn''t passed')
                [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
                [CompletionResult]::new('--enable-testing-features-do-not-use', 'enable-testing-features-do-not-use', [CompletionResultType]::ParameterName, 'INTERNAL: Enable internal features used during integration testing')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;completions' {
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;coverage' {
                [CompletionResult]::new('--ignore', 'ignore', [CompletionResultType]::ParameterName, 'Ignore coverage files')
                [CompletionResult]::new('--include', 'include', [CompletionResultType]::ParameterName, 'Include source files in the report')
                [CompletionResult]::new('--exclude', 'exclude', [CompletionResultType]::ParameterName, 'Exclude source files from the report')
                [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'Output file (defaults to stdout) for lcov')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--lcov', 'lcov', [CompletionResultType]::ParameterName, 'Output coverage report in lcov format')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;doc' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--json', 'json', [CompletionResultType]::ParameterName, 'Output documentation in JSON format')
                [CompletionResult]::new('--private', 'private', [CompletionResultType]::ParameterName, 'Output private documentation')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;eval' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port (default: 127.0.0.1:9229)')
                [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and break at start of user script')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Value of ''globalThis.location'' used by some web APIs')
                [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options')
                [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
                [CompletionResult]::new('--ext', 'ext', [CompletionResultType]::ParameterName, 'Set standard input (stdin) content type')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
                [CompletionResult]::new('--enable-testing-features-do-not-use', 'enable-testing-features-do-not-use', [CompletionResultType]::ParameterName, 'INTERNAL: Enable internal features used during integration testing')
                [CompletionResult]::new('-T', 'T', [CompletionResultType]::ParameterName, 'Treat eval input as TypeScript')
                [CompletionResult]::new('--ts', 'ts', [CompletionResultType]::ParameterName, 'Treat eval input as TypeScript')
                [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'print result to stdout')
                [CompletionResult]::new('--print', 'print', [CompletionResultType]::ParameterName, 'print result to stdout')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;fmt' {
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--ext', 'ext', [CompletionResultType]::ParameterName, 'Set standard input (stdin) content type')
                [CompletionResult]::new('--ignore', 'ignore', [CompletionResultType]::ParameterName, 'Ignore formatting particular source files')
                [CompletionResult]::new('--options-line-width', 'options-line-width', [CompletionResultType]::ParameterName, 'Define maximum line width. Defaults to 80.')
                [CompletionResult]::new('--options-indent-width', 'options-indent-width', [CompletionResultType]::ParameterName, 'Define indentation width. Defaults to 2.')
                [CompletionResult]::new('--options-prose-wrap', 'options-prose-wrap', [CompletionResultType]::ParameterName, 'Define how prose should be wrapped. Defaults to always.')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Check if the source files are formatted')
                [CompletionResult]::new('--watch', 'watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart automatically')
                [CompletionResult]::new('--no-clear-screen', 'no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
                [CompletionResult]::new('--options-use-tabs', 'options-use-tabs', [CompletionResultType]::ParameterName, 'Use tabs instead of spaces for indentation. Defaults to false.')
                [CompletionResult]::new('--options-single-quote', 'options-single-quote', [CompletionResultType]::ParameterName, 'Use single quotes. Defaults to false.')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;init' {
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;info' {
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Show files used for origin bound APIs like the Web Storage API when running a script with ''--location=<HREF>''')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--json', 'json', [CompletionResultType]::ParameterName, 'UNSTABLE: Outputs the information in JSON format')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;install' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
                [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
                [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
                [CompletionResult]::new('--unsafely-ignore-certificate-errors', 'unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
                [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
                [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
                [CompletionResult]::new('--allow-ffi', 'allow-ffi', [CompletionResultType]::ParameterName, 'Allow loading dynamic libraries')
                [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port (default: 127.0.0.1:9229)')
                [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and break at start of user script')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Value of ''globalThis.location'' used by some web APIs')
                [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options')
                [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
                [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'Executable file name')
                [CompletionResult]::new('--name', 'name', [CompletionResultType]::ParameterName, 'Executable file name')
                [CompletionResult]::new('--root', 'root', [CompletionResultType]::ParameterName, 'Installation root')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
                [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--prompt', 'prompt', [CompletionResultType]::ParameterName, 'deprecated: Fallback to prompt if required permission wasn''t passed')
                [CompletionResult]::new('--no-prompt', 'no-prompt', [CompletionResultType]::ParameterName, 'Always throw if required permission wasn''t passed')
                [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
                [CompletionResult]::new('--enable-testing-features-do-not-use', 'enable-testing-features-do-not-use', [CompletionResultType]::ParameterName, 'INTERNAL: Enable internal features used during integration testing')
                [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Forcefully overwrite existing installation')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Forcefully overwrite existing installation')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;uninstall' {
                [CompletionResult]::new('--root', 'root', [CompletionResultType]::ParameterName, 'Installation root')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;lsp' {
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;lint' {
                [CompletionResult]::new('--rules-tags', 'rules-tags', [CompletionResultType]::ParameterName, 'Use set of rules with a tag')
                [CompletionResult]::new('--rules-include', 'rules-include', [CompletionResultType]::ParameterName, 'Include lint rules')
                [CompletionResult]::new('--rules-exclude', 'rules-exclude', [CompletionResultType]::ParameterName, 'Exclude lint rules')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--ignore', 'ignore', [CompletionResultType]::ParameterName, 'Ignore linting particular source files')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--rules', 'rules', [CompletionResultType]::ParameterName, 'List available rules')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--json', 'json', [CompletionResultType]::ParameterName, 'Output lint result in JSON format')
                [CompletionResult]::new('--watch', 'watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart automatically')
                [CompletionResult]::new('--no-clear-screen', 'no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;repl' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port (default: 127.0.0.1:9229)')
                [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and break at start of user script')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Value of ''globalThis.location'' used by some web APIs')
                [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options')
                [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
                [CompletionResult]::new('--eval-file', 'eval-file', [CompletionResultType]::ParameterName, 'Evaluates the provided file(s) as scripts when the REPL starts. Accepts file paths and URLs.')
                [CompletionResult]::new('--eval', 'eval', [CompletionResultType]::ParameterName, 'Evaluates the provided code when the REPL starts.')
                [CompletionResult]::new('--unsafely-ignore-certificate-errors', 'unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
                [CompletionResult]::new('--enable-testing-features-do-not-use', 'enable-testing-features-do-not-use', [CompletionResultType]::ParameterName, 'INTERNAL: Enable internal features used during integration testing')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;run' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
                [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
                [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
                [CompletionResult]::new('--unsafely-ignore-certificate-errors', 'unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
                [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
                [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
                [CompletionResult]::new('--allow-ffi', 'allow-ffi', [CompletionResultType]::ParameterName, 'Allow loading dynamic libraries')
                [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port (default: 127.0.0.1:9229)')
                [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and break at start of user script')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Value of ''globalThis.location'' used by some web APIs')
                [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options')
                [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
                [CompletionResult]::new('--watch', 'watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart automatically')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
                [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--prompt', 'prompt', [CompletionResultType]::ParameterName, 'deprecated: Fallback to prompt if required permission wasn''t passed')
                [CompletionResult]::new('--no-prompt', 'no-prompt', [CompletionResultType]::ParameterName, 'Always throw if required permission wasn''t passed')
                [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
                [CompletionResult]::new('--enable-testing-features-do-not-use', 'enable-testing-features-do-not-use', [CompletionResultType]::ParameterName, 'INTERNAL: Enable internal features used during integration testing')
                [CompletionResult]::new('--no-clear-screen', 'no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;task' {
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--cwd', 'cwd', [CompletionResultType]::ParameterName, 'Specify the directory to run the task in')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;test' {
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--no-check', 'no-check', [CompletionResultType]::ParameterName, 'Skip type-checking modules')
                [CompletionResult]::new('--check', 'check', [CompletionResultType]::ParameterName, 'Type-check modules')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('--allow-read', 'allow-read', [CompletionResultType]::ParameterName, 'Allow file system read access')
                [CompletionResult]::new('--allow-write', 'allow-write', [CompletionResultType]::ParameterName, 'Allow file system write access')
                [CompletionResult]::new('--allow-net', 'allow-net', [CompletionResultType]::ParameterName, 'Allow network access')
                [CompletionResult]::new('--unsafely-ignore-certificate-errors', 'unsafely-ignore-certificate-errors', [CompletionResultType]::ParameterName, 'DANGER: Disables verification of TLS certificates')
                [CompletionResult]::new('--allow-env', 'allow-env', [CompletionResultType]::ParameterName, 'Allow environment access')
                [CompletionResult]::new('--allow-run', 'allow-run', [CompletionResultType]::ParameterName, 'Allow running subprocesses')
                [CompletionResult]::new('--allow-ffi', 'allow-ffi', [CompletionResultType]::ParameterName, 'Allow loading dynamic libraries')
                [CompletionResult]::new('--inspect', 'inspect', [CompletionResultType]::ParameterName, 'Activate inspector on host:port (default: 127.0.0.1:9229)')
                [CompletionResult]::new('--inspect-brk', 'inspect-brk', [CompletionResultType]::ParameterName, 'Activate inspector on host:port and break at start of user script')
                [CompletionResult]::new('--location', 'location', [CompletionResultType]::ParameterName, 'Value of ''globalThis.location'' used by some web APIs')
                [CompletionResult]::new('--v8-flags', 'v8-flags', [CompletionResultType]::ParameterName, 'Set V8 command line options')
                [CompletionResult]::new('--seed', 'seed', [CompletionResultType]::ParameterName, 'Set the random number generator seed')
                [CompletionResult]::new('--ignore', 'ignore', [CompletionResultType]::ParameterName, 'Ignore files')
                [CompletionResult]::new('--fail-fast', 'fail-fast', [CompletionResultType]::ParameterName, 'Stop after N errors. Defaults to stopping after first failure.')
                [CompletionResult]::new('--filter', 'filter', [CompletionResultType]::ParameterName, 'Run tests with this string or pattern in the test name')
                [CompletionResult]::new('--shuffle', 'shuffle', [CompletionResultType]::ParameterName, '(UNSTABLE): Shuffle the order in which the tests are run')
                [CompletionResult]::new('--coverage', 'coverage', [CompletionResultType]::ParameterName, 'UNSTABLE: Collect coverage profile data into DIR')
                [CompletionResult]::new('-j', 'j', [CompletionResultType]::ParameterName, 'deprecated: Number of parallel workers, defaults to number of available CPUs when no value is provided. Defaults to 1 when the option is not present.')
                [CompletionResult]::new('--jobs', 'jobs', [CompletionResultType]::ParameterName, 'deprecated: Number of parallel workers, defaults to number of available CPUs when no value is provided. Defaults to 1 when the option is not present.')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--no-remote', 'no-remote', [CompletionResultType]::ParameterName, 'Do not resolve remote modules')
                [CompletionResult]::new('--node-modules-dir', 'node-modules-dir', [CompletionResultType]::ParameterName, 'Creates a local node_modules folder')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('--lock-write', 'lock-write', [CompletionResultType]::ParameterName, 'Write lock file (use with --lock)')
                [CompletionResult]::new('--allow-hrtime', 'allow-hrtime', [CompletionResultType]::ParameterName, 'Allow high resolution time measurement')
                [CompletionResult]::new('-A', 'A', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--allow-all', 'allow-all', [CompletionResultType]::ParameterName, 'Allow all permissions')
                [CompletionResult]::new('--prompt', 'prompt', [CompletionResultType]::ParameterName, 'deprecated: Fallback to prompt if required permission wasn''t passed')
                [CompletionResult]::new('--no-prompt', 'no-prompt', [CompletionResultType]::ParameterName, 'Always throw if required permission wasn''t passed')
                [CompletionResult]::new('--cached-only', 'cached-only', [CompletionResultType]::ParameterName, 'Require that remote dependencies are already cached')
                [CompletionResult]::new('--enable-testing-features-do-not-use', 'enable-testing-features-do-not-use', [CompletionResultType]::ParameterName, 'INTERNAL: Enable internal features used during integration testing')
                [CompletionResult]::new('--no-run', 'no-run', [CompletionResultType]::ParameterName, 'Cache test modules, but don''t run tests')
                [CompletionResult]::new('--trace-ops', 'trace-ops', [CompletionResultType]::ParameterName, 'Enable tracing of async ops. Useful when debugging leaking ops in test, but impacts test execution time.')
                [CompletionResult]::new('--doc', 'doc', [CompletionResultType]::ParameterName, 'UNSTABLE: type-check code blocks')
                [CompletionResult]::new('--allow-none', 'allow-none', [CompletionResultType]::ParameterName, 'Don''t return error code if no test files are found')
                [CompletionResult]::new('--parallel', 'parallel', [CompletionResultType]::ParameterName, 'Run test modules in parallel. Parallelism defaults to the number of available CPUs or the value in the DENO_JOBS environment variable.')
                [CompletionResult]::new('--watch', 'watch', [CompletionResultType]::ParameterName, 'Watch for file changes and restart automatically')
                [CompletionResult]::new('--no-clear-screen', 'no-clear-screen', [CompletionResultType]::ParameterName, 'Do not clear terminal screen when under watch mode')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;types' {
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;upgrade' {
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'The version to upgrade to')
                [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'The path to output the updated version to')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--dry-run', 'dry-run', [CompletionResultType]::ParameterName, 'Perform all checks without replacing old exe')
                [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Replace current exe even if not out-of-date')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Replace current exe even if not out-of-date')
                [CompletionResult]::new('--canary', 'canary', [CompletionResultType]::ParameterName, 'Upgrade to canary builds')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;vendor' {
                [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'The directory to output the vendored modules to')
                [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Specify the configuration file')
                [CompletionResult]::new('--import-map', 'import-map', [CompletionResultType]::ParameterName, 'Load import map file')
                [CompletionResult]::new('--lock', 'lock', [CompletionResultType]::ParameterName, 'Check the specified lock file')
                [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--reload', 'reload', [CompletionResultType]::ParameterName, 'Reload source code cache (recompile TypeScript)')
                [CompletionResult]::new('--cert', 'cert', [CompletionResultType]::ParameterName, 'Load certificate authority from PEM encoded file')
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Forcefully overwrite conflicting files in existing output directory')
                [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Forcefully overwrite conflicting files in existing output directory')
                [CompletionResult]::new('--no-config', 'no-config', [CompletionResultType]::ParameterName, 'Disable automatic loading of the configuration file.')
                [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
            'deno;help' {
                [CompletionResult]::new('-L', 'L', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'Set log level')
                [CompletionResult]::new('--unstable', 'unstable', [CompletionResultType]::ParameterName, 'Enable unstable features and APIs')
                [CompletionResult]::new('-q', 'q', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Suppress diagnostic output')
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
    Sort-Object -Property ListItemText
}

# -------------------------------------------------------------------------------------
# `fnm` (fast NodeJS Manager) auto completion 
Register-ArgumentCompleter -Native -CommandName 'fnm' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'fnm'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
            }
            $element.Value
        }) -join ';'

    $completions = @(switch ($command) {
            'fnm' {
                [CompletionResult]::new('--node-dist-mirror', 'node-dist-mirror', [CompletionResultType]::ParameterName, 'https://nodejs.org/dist/ mirror')
                [CompletionResult]::new('--fnm-dir', 'fnm-dir', [CompletionResultType]::ParameterName, 'The root directory of fnm installations')
                [CompletionResult]::new('--multishell-path', 'multishell-path', [CompletionResultType]::ParameterName, 'Where the current node version link is stored. This value will be populated automatically by evaluating `fnm env` in your shell profile. Read more about it using `fnm help env`')
                [CompletionResult]::new('--log-level', 'log-level', [CompletionResultType]::ParameterName, 'The log level of fnm commands')
                [CompletionResult]::new('--arch', 'arch', [CompletionResultType]::ParameterName, 'Override the architecture of the installed Node binary. Defaults to arch of fnm binary')
                [CompletionResult]::new('--version-file-strategy', 'version-file-strategy', [CompletionResultType]::ParameterName, 'A strategy for how to resolve the Node version. Used whenever `fnm use` or `fnm install` is called without a version, or when `--use-on-cd` is configured on evaluation')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                [CompletionResult]::new('list-remote', 'list-remote', [CompletionResultType]::ParameterValue, 'List all remote Node.js versions')
                [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'List all locally installed Node.js versions')
                [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Install a new Node.js version')
                [CompletionResult]::new('use', 'use', [CompletionResultType]::ParameterValue, 'Change Node.js version')
                [CompletionResult]::new('env', 'env', [CompletionResultType]::ParameterValue, 'Print and set up required environment variables for fnm')
                [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Print shell completions to stdout')
                [CompletionResult]::new('alias', 'alias', [CompletionResultType]::ParameterValue, 'Alias a version to a common name')
                [CompletionResult]::new('unalias', 'unalias', [CompletionResultType]::ParameterValue, 'Remove an alias definition')
                [CompletionResult]::new('default', 'default', [CompletionResultType]::ParameterValue, 'Set a version as the default version')
                [CompletionResult]::new('current', 'current', [CompletionResultType]::ParameterValue, 'Print the current Node.js version')
                [CompletionResult]::new('exec', 'exec', [CompletionResultType]::ParameterValue, 'Run a command within fnm context')
                [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstall a Node.js version')
                break
            }
            'fnm;list-remote' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
            'fnm;list' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
            'fnm;install' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                [CompletionResult]::new('--lts', 'lts', [CompletionResultType]::ParameterName, 'Install latest LTS')
                break
            }
            'fnm;use' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                [CompletionResult]::new('--install-if-missing', 'install-if-missing', [CompletionResultType]::ParameterName, 'Install the version if it isn''t installed yet')
                [CompletionResult]::new('--silent-if-unchanged', 'silent-if-unchanged', [CompletionResultType]::ParameterName, 'Don''t output a message identifying the version being used if it will not change due to execution of this command')
                break
            }
            'fnm;env' {
                [CompletionResult]::new('--shell', 'shell', [CompletionResultType]::ParameterName, 'The shell syntax to use. Infers when missing')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                [CompletionResult]::new('--multi', 'multi', [CompletionResultType]::ParameterName, 'Deprecated. This is the default now')
                [CompletionResult]::new('--use-on-cd', 'use-on-cd', [CompletionResultType]::ParameterName, 'Print the script to change Node versions every directory change')
                break
            }
            'fnm;completions' {
                [CompletionResult]::new('--shell', 'shell', [CompletionResultType]::ParameterName, 'The shell syntax to use. Infers when missing')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
            'fnm;alias' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
            'fnm;unalias' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
            'fnm;default' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
            'fnm;current' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
            'fnm;exec' {
                [CompletionResult]::new('--using', 'using', [CompletionResultType]::ParameterName, 'Either an explicit version, or a filename with the version written in it')
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                [CompletionResult]::new('--using-file', 'using-file', [CompletionResultType]::ParameterName, 'Deprecated. This is the default now')
                break
            }
            'fnm;uninstall' {
                [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
                [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
                break
            }
        })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
    Sort-Object -Property ListItemText
}

