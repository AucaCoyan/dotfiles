# cd into repos/dotfiles && code .
export def --env dotfiles [] {
    if $nu.os-info.name == "windows" {
        cd ~\repos\dotfiles\
    } else if $nu.os-info.name == "linux" {
        cd ~/repos/dotfiles/
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    code .
}

# cd into ~\other-repos\nu\nu_scripts\ && code .
export def --env nu_scripts [] {
    if $nu.os-info.name == "windows" {
        cd ~\other-repos\nu\nu_scripts\
    } else if $nu.os-info.name == "linux" {
        cd ~/other-repos/nu/nu_scripts/
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    code .
}

# cd into AppData/local/nvim/lua/custom && nvim .
export def --env vimrc [] {
    if $nu.os-info.name == "windows" {
        cd ~\AppData\Local\nvim\lua\custom
        nvim .
    } else {
        error make {msg: "Not implemented other OS other than Windows", } 
    }
}
