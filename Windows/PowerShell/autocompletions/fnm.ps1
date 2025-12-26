# imports for autocompletion
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

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
