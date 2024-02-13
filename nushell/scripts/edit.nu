# cd into repos/dotfiles && code .
export def --env dotfiles [] {
    if $nu.os-info.name == "windows" {
        cd ~\repos\dotfiles\
    } else if $nu.os-info.name == "linux" {
        cd ~/repos/dotfiles/
    } else {
        throw "Could not find the OS name :("
    }
    code .
}

# cd into ~\other-repos\nu\nu_scripts\ && code .
export def nu_scripts [] {
    cd ~\other-repos\nu\nu_scripts\
    code .
}

# cd into AppData/local/nvim/lua/custom && nvim .
export def vimrc [] {
    cd ~\AppData\Local\nvim\lua\custom
    nvim .
}
