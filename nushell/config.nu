# log format
$env.NU_LOG_FORMAT = $"%ANSI_START%%DATE%|%LEVEL%|%MSG%%ANSI_STOP%"
$env.NU_LOG_DATE_FORMAT = "%Y-%m-%dT%H:%M:%S%.3f"

# env.nu
$env.home = if $nu.os-info.name == "windows" {
            $env.USERPROFILE
        } else {
            $env.HOME
        }

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# # Directories to search for scripts when calling source or use
# # The default for this is $nu.default-config-dir/scripts
# $env.NU_LIB_DIRS = [
#     ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
# ]
#
# # Directories to search for plugin binaries when calling register
# # The default for this is $nu.default-config-dir/plugins
# $env.NU_PLUGIN_DIRS = [
#     ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
# ]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# me abre una ventana de code cada vez que abro nu
#$env.EDITOR = code

if $nu.os-info.name == "windows" {
} else if $nu.os-info.name == "linux" {
    # Documentation for nvim
    # alias nvim = "~/bin/nvim"
    $env.PYENV_ROOT = "$HOME/bin/.pyenv"
    $env.BUN_INSTALL = "$HOME/.bun"
    $env.PNPM_HOME = "$HOME/.local/share/pnpm"
    $env.DEBUGINFOD_URLS = "https://debuginfod.debian.net"
    $env.PATH = ($env.PATH | split row (char esep) | append '~/.cargo/bin')
    $env.PATH = ($env.PATH | split row (char esep) | append '~/.bun/bin')
    $env.PATH = ($env.PATH | split row (char esep) | append '~/.local/share/pnpm')
    $env.PATH = ($env.PATH | split row (char esep) | append '~/.local/share/fnm')
    $env.PATH = ($env.PATH | split row (char esep) | append '~/.local/kitty.app')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '~/.zig/')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '~/Applications')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '~/bin' | uniq )
    # hombrew
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/home/linuxbrew/.linuxbrew/bin')
    # nix-shell
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/nix/var/nix/profiles/default/bin')
}

# import the theme
# use ~/repos/dotfiles/nushell/themes/base16.nu base16_theme 

# config.nu
$env.config = {

    show_banner: false # true or false to enable or disable the welcome banner at startup
    rm: {
        always_trash: true # always act as if -t was given. Can be overridden with -p
    }

    table: {
        mode: light # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    }

    history: {
        file_format: "sqlite" # "sqlite" or "plaintext"
    }
    # color_config: $base16_theme
    # color_config: $light_theme
}

# source ~/other-repos/nu/nu_scripts/themes/nu-themes/dracula.nu

# theme
# https://github.com/nushell/nu_scripts/tree/main/themes
# use ~/other-repos/nu/nu_scripts/themes/nu-themes/catppuccin-mocha.nu
# $env.config = ($env.config | merge {color_config: (catppuccin-mocha)})

# use nupm
# use ~/other-repos/nupm/nupm/

# make `fnm` nushell compatible
use ~/other-repos/nu/nu_scripts/modules/fnm/fnm.nu

# `cfg-files`
source ~/repos/dotfiles/nushell/cfg_files/my-aliases.nu

# `custom-completions`
source ~/other-repos/nu/nu_scripts/custom-completions/bat/bat-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/bmc/bmc-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/cargo/cargo-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/cargo-make/cargo-make-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/curl/curl-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/just/just-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/flutter/flutter-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/fd/fd-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/gcloud/gcloud-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/gh/gh-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/git/git-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/make/make-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/npm/npm-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/pnpm/pnpm-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/poetry/poetry-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/rg/rg-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/rye/rye-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/rustup/rustup-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/scoop/scoop-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/tealdeer/tldr-completions.nu
source ~/other-repos/nu/nu_scripts/custom-completions/vscode/vscode-completions.nu
# source ~/other-repos/nu/nu_scripts/custom-completions/yarn/yarn-v4-completions.nu

# `auto-generate`
# source ~/other-repos/nu/nu_scripts/custom-completions/auto-generate/completions/dotnet.nu

# use ~/other-repos/nu/nu_scripts/modules/with_externals/loc.nu

# fzf searches
source ~/other-repos/nu/nu_scripts/modules/fuzzy/fuzzy_history_search.nu
source ~/other-repos/nu/nu_scripts/modules/fuzzy/fuzzy_command_search.nu

if $nu.os-info.name == "linux" {
    source ~/repos/dotfiles/nushell/cfg_files/oh-my-posh-linux.nu
} else if $nu.os-info.name == "windows" {
    source ~/repos/dotfiles/nushell/cfg_files/oh-my-posh-windows.nu

    let has_ligh_theme = (pwsh -c "Get-ItemPropertyValue -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize' -Name 'SystemUsesLightTheme'")
    if ($has_ligh_theme == '1') {
        use ~/other-repos/nu/nu_scripts/themes/nu-themes/github-light-default.nu
        $env.config = ($env.config | merge {color_config: (github-light-default)})
    }
    if ($env.USERNAME == 'AucaMaillo') {
        # use ~/workspace/gcp-source/all-bots/nushell/all-workspace.nu *
        # source ~/workspace/gcp-source/warden/shell_completions/nushell/warden-completions.nu
    }

} else if $nu.os-info.name == "macos" {
    source ~/repos/dotfiles/nushell/cfg_files/oh-my-posh-macos.nu
}

# import the module scripts
use ~/repos/dotfiles/nushell/scripts/ *
