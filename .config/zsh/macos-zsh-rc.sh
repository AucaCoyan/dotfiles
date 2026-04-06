#!/usr/bin/bash

# oh-my-zsh setup (macOS only)
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="random"
ZSH_THEME="agnoster"

# Themes I tried and didn't like
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

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
         zsh-autosuggestions
         colored-man-pages          # add colors to manpages
         colorize                   # cat syntax highlight support
         cp                         # cp now has a progress bar
         fzf-tab
         vi-mode                    # vi-mode in zsh.... wait what?
     )

source $ZSH/oh-my-zsh.sh

# Then source your shared config
source ~/repos/dotfiles/.config/zsh/.zshrc

# source fzf-file-widget
source ~/repos/dotfiles/.config/fzf-file-widget.sh

# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/aucamaillot/.zsh/completions:"* ]]; then export FPATH="/Users/aucamaillot/.zsh/completions:$FPATH"; fi
. "/Users/aucamaillot/.deno/env"
# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# make node-gyp use specifically this python
export NODE_GYP_FORCE_PYTHON=$HOME/.local/bin/python3.10