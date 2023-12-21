# cd into repos/dotfiles && code .
export def dotfiles [] {
    cd ~\repos\dotfiles\
    code .
}

# cd into AppData/local/nvim/lua/custom && nvim .
export def nu_scripts [] {
    cd ~\other-repos\nu\nu_scripts\
    code .
}

# cd into AppData/local/nvim/lua/custom && nvim .
export def vimrc [] {
    cd ~\AppData\Local\nvim\lua\custom
    nvim .
}
