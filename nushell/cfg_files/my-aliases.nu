# Documentation for ls
## separate files and folders
# you cannont overshadow builtins
# https://www.nushell.sh/blog/2023-03-14-nushell_0_77.html#reworked-aliases-breaking-changes-kubouch
# alias ls = (ls | sort-by type)

# side by side comparision
alias diff = delta

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
alias nv = nvim -u ~\repos\dotfiles\.config\nvim\init.lua

# sqlite
alias sqlite = sqlite3
alias "sqlite -h" = sqlite3 -help
# z autojump
# to make it easier to jump between directories, I strictly go to aliases, which is faster
# alias zd = (z dotfiles)  # it doesn't work

# quit the terminal faster
alias :q = exit

