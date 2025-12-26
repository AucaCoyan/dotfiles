# Documentation for ls
## separate files and folders
# you cannont overshadow builtins
# https://www.nushell.sh/blog/2023-03-14-nushell_0_77.html#reworked-aliases-breaking-changes-kubouch
# alias ls = (ls | sort-by type)

# side by side comparision
alias diff = delta
alias 'git diff' = git diff-words

# misspellings for clear, cd
alias cler =  clear
alias clar =  clear
alias claer =  clear
alias CD = cd
alias .. = cd ..

# misspellings for scoop
alias scoo = scoop

# nvim configurations
# my vim
# alias nv = nvim -u ~\repos\dotfiles\.config\nvim\init.lua
# alias nvim = code
# alias vim = code
# alias vi = code

# sqlite
alias sqlite = sqlite3
alias "sqlite -h" = sqlite3 -help
# z autojump
# to make it easier to jump between directories, I strictly go to aliases, which is faster
# alias zd = (z dotfiles)  # it doesn't work

# quit the terminal faster
alias :q = exit
alias "git_log1" = git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
alias "git_log2" = git log --all --decorate --oneline

# show installed packages in cargo
# TODO: print "running `cargo install --list`"
alias "cargo list" = cargo install --list
alias "cargo --list" = cargo install --list

# set the theme for `gitui` and `bat
alias bat = bat --theme="gruvbox-dark"
alias cat = bat --theme="gruvbox-dark"

# toolkit
alias "check pr" = toolkit check pr

# espanso
if $nu.os-info.name == "linux" {
    null
} else if $nu.os-info.name == "windows" {
    alias espanso = espansod
}

alias l = lazygit

# python
# doesn't work
# alias "venv activate" = (overlay use .venv\Scripts\activate.nu)

# gitmoji
alias "gimtoji commit" = gitmoji commit

# riggrep
# doesn't grab the search pattern after `rg`
# alias "rg" = rg --hidden

# fzf
alias hi = fuzzy-history-search
alias hf = fuzzy-command-search

alias sail = vendor/bin/sail
