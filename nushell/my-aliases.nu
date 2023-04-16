# Documentation for ls
## separate files and folders
# you cannont overshadow builtins
# https://www.nushell.sh/blog/2023-03-14-nushell_0_77.html#reworked-aliases-breaking-changes-kubouch
# alias ls = (ls | sort-by type)

# side by side comparision
alias diff = delta

# misspellings for clear
alias cler =  clear
alias clar =  clear
alias claer =  clear

# misspellings for scoop
alias scoo = scoop

# nvim configurations
# my vim
alias nv = nvim -u ~\repos\dotfiles\.config\nvim\init.lua

# sqlite
alias sqlite = sqlite3
