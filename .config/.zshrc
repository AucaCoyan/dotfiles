# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="random"
ZSH_THEME="agnoster"

# Themes I tried and didn't liked it
# blinks
# edvardm
# jonathan
# linuxonly
# norm
# re5et

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git                        # git
         colored-man-pages          # add colors to manpages
         colorize                   # cat syntax highlight support
         command-not-found          # suggest package name with relevant command
         cp                         # cp now has a progress bar
        #vi-mode                    # vi-mode in zsh.... wait what?
         themes                     # theme switcher (w/o editing .zshrc)
         zsh-autosuggestions        # autocomplete
         gh                         # autocomplete for GH CLI
     )

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

function f {
    # 1. Define and convert directories from Windows-style to Unix-style
    # In Zsh/Unix, $HOME is used, and paths use forward slashes.
    local directories=(
        "$HOME/repos"
        "$HOME/other-repos"
        "$HOME/other-repos/espanso"
        "$HOME/other-repos/nu"
        "$HOME/workspace"
        "$HOME/workspace/private"
    )

    # 2. Run fd and pipe its output to a variable
    # The PowerShell script passes the directories as positional arguments to fd.
    # The '.' argument is present but seems redundant if directories are specified,
    # but we'll include it for a faithful translation if 'fd' is expecting it.
    local fd_output
    fd_output=$(
        fd --max-depth 1 \
           --min-depth 1 \
           --type directory \
           --hidden \
           --no-ignore \
           --ignore-vcs \
           --exclude node_modules \
           . "${directories[@]}"
    )

    # Check if fd found any directories
    if [[ -z "$fd_output" ]]; then
        echo "Warning: 'fd' did not find any directories." >&2
        return 1
    fi

    local selected_directory
    
    # 3. Check for fzf and use it for selection
    # `type fzf` attempts to locate the command. `&>/dev/null` suppresses its output.
    if type fzf &>/dev/null; then
        # Use fzf to select a directory from the fd output
        # The output of fzf is piped to 'read'
        selected_directory=$(echo "$fd_output" | fzf)
    else
        echo "Warning: fzf is not installed. Using the first directory found by fd." >&2
        # Use the first line of the output if fzf is not available
        # The `read -r` command reads the first line from the string.
        selected_directory=$(echo "$fd_output" | head -n 1)
    fi

    # 4. Change directory
    if [[ -n "$selected_directory" ]]; then
        if cd "$selected_directory"; then
            # Successfully changed directory
            echo "Changed directory to: $selected_directory"
            return 0
        else
            # Error changing directory
            echo "Error: Failed to change directory to '$selected_directory'." >&2
            return 1
        fi
    else
        echo "Warning: No directory selected." >&2
        return 1
    fi
}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
# Example aliases
alias zshconfig="nvim ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

########################################### starship ######################################
# Install starship/starship in .zshrc
eval "$(starship init zsh)"

######################################## zsh autocomplete #################################
# set Tab key to autocomplete
bindkey '^I' autosuggest-accept

# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/aucamaillot/.zsh/completions:"* ]]; then export FPATH="/Users/aucamaillot/.zsh/completions:$FPATH"; fi
. "/Users/aucamaillot/.deno/env"
# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit
# bun completions
[ -s "/Users/aucamaillot/.bun/_bun" ] && source "/Users/aucamaillot/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# make node-gyp use specifically this python
export NODE_GYP_FORCE_PYTHON=$HOME/.local/bin/python3.10
