# make sure we have the right prompt render correctly
if ($env.config? | is-not-empty) {
$env.config = ($env.config | upsert render_right_prompt_on_last_line true)
}

$env.POWERLINE_COMMAND = 'oh-my-posh'
$env.POSH_THEME = "/home/acoyan/repos/dotfiles/nushell/cfg_files/oh-my-posh.config.json"
$env.PROMPT_INDICATOR = ""
$env.POSH_PID = (random uuid)
$env.POSH_SHELL_VERSION = (version | get version)

# let _omp_executable: string = (echo "/home/linuxbrew/.linuxbrew/Cellar/oh-my-posh/23.14.1/bin/oh-my-posh")
let _omp_executable: string = (echo "/home/linuxbrew/.linuxbrew/bin/oh-my-posh")

# PROMPTS

def --wrapped _omp_get_prompt [
    type: string,
    ...args: string
] {
    mut execution_time = -1
    mut no_status = true
    # We have to do this because the initial value of `$env.CMD_DURATION_MS` is always `0823`, which is an official setting.
    # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
    if $env.CMD_DURATION_MS != '0823' {
        $execution_time = $env.CMD_DURATION_MS
        $no_status = false
    }

    (
        ^$_omp_executable print $type
            --save-cache
            --shell=nu
            $"--shell-version=($env.POSH_SHELL_VERSION)"
            $"--status=($env.LAST_EXIT_CODE)"
            $"--no-status=($no_status)"
            $"--execution-time=($execution_time)"
            $"--terminal-width=((term size).columns)"
            ...$args
    )
}

$env.PROMPT_MULTILINE_INDICATOR = (
    ^$_omp_executable print secondary
        --shell=nu
        $"--shell-version=($env.POSH_SHELL_VERSION)"
)

$env.PROMPT_COMMAND = {||
    # hack to set the cursor line to 1 when the user clears the screen
    # this obviously isn't bulletproof, but it's a start
    mut clear = false
    if $nu.history-enabled {
        $clear = (history | is-empty) or ((history | last 1 | get 0.command) == "clear")
    }

    if ($env.SET_POSHCONTEXT? | is-not-empty) {
        do --env $env.SET_POSHCONTEXT
    }

    _omp_get_prompt primary $"--cleared=($clear)"
}

$env.PROMPT_COMMAND_RIGHT = {|| _omp_get_prompt right }

^$_omp_executable notice

# --------------------------------------------------------------------------------------------
# Old config:
# def posh_cmd_duration [] {
#     # We have to do this because the initial value of `$env.CMD_DURATION_MS` is always `0823`,
#     # which is an official setting.
#     # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
#     if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS }
# }

# def posh_width [] {
#     (term size).columns | into string
# }

# # PROMPTS
# $env.PROMPT_MULTILINE_INDICATOR = (^"/home/linuxbrew/.linuxbrew/bin/oh-my-posh" print secondary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)")

# $env.PROMPT_COMMAND = { ||
#     # hack to set the cursor line to 1 when the user clears the screen
#     # this obviously isn't bulletproof, but it's a start
#     # let clear = (history | last 1 | get 0.command) == "clear"

#     ^"/home/linuxbrew/.linuxbrew/bin/oh-my-posh" print primary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)" $"--execution-time=(posh_cmd_duration)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=(posh_width)"
# }

# $env.PROMPT_COMMAND_RIGHT = { ||    
#     ^"/home/linuxbrew/.linuxbrew/bin/oh-my-posh" print right $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)" $"--execution-time=(posh_cmd_duration)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=(posh_width)"
# }

# if "true" == "true" {
#     $env.TRANSIENT_PROMPT_COMMAND = { ||
#         ^"/home/linuxbrew/.linuxbrew/bin/oh-my-posh" print transient $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)" $"--execution-time=(posh_cmd_duration)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=(posh_width)"
#     }
# }

# if "false" == "true" {
#     echo ""
# }
