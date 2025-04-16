
export-env {
    let _omp_executable: string = (echo $"($env.home)/scoop/apps/oh-my-posh/current/oh-my-posh.exe")
    $env.POWERLINE_COMMAND = 'oh-my-posh'
    $env.POSH_THEME = ([$env.home, "\\repos\\dotfiles\\nushell\\cfg_files\\oh-my-posh.config.json"] | str join)
    $env.PROMPT_INDICATOR = ""
    $env.POSH_PID = (random uuid)
    # By default displays the right prompt on the first line
    # making it annoying when you have a multiline prompt
    # making the behavior different compared to other shells
    $env.PROMPT_COMMAND_RIGHT = {|| ''}
    $env.NU_VERSION = (version | get version)

    # PROMPTS
    $env.PROMPT_MULTILINE_INDICATOR = (^(
        [$env.home, "\\scoop\\apps\\oh-my-posh\\current\\oh-my-posh.exe"]
        | str join
        ) print secondary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.NU_VERSION)")

    $env.PROMPT_COMMAND = { ||
        # We have to do this because the initial value of `$env.CMD_DURATION_MS` is always `0823`,
        # which is an official setting.
        # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
        let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS }

        let width = ((term size).columns | into string)
        ^(
    [$env.home, "\\scoop\\apps\\oh-my-posh\\current\\oh-my-posh.exe"]
    | str join) print primary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.NU_VERSION)" $"--execution-time=($cmd_duration)" $"--terminal-width=($width)"
    }
}
