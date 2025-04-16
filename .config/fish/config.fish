if status is-interactive
    # Commands to run in interactive sessions can go here
end

# disables the greeting
set fish_greeting

bind \t accept-autosuggestion
alias so="source"
alias zshconfig="nvim ~/.zshrc"
alias fishconfig="nvim ~/.config/fish/config.fish"
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias ls="exa --long --sort=type"
alias config='/usr/bin/git --git-dir=/home/auca/.cfg/ --work-tree=/home/auca'
alias explorer='nautilus'
alias python='python3'
alias bat='batcat'
alias cat='batcat'
alias grep='rgrep'


# Set the fish-colored-man plugin to
# Solarized Dark & Green highlight
set -g man_blink -o red
set -g man_bold -o green
set -g man_standout -b black d33682
set -g man_underline -u 93a1a1

#export cargo config
export PATH="$HOME/.cargo/bin:$PATH"

# pnpm
set -gx PNPM_HOME "/home/auca/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
