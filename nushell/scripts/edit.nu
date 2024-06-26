# cd into repos/dotfiles && $EDITOR .
export def --env dotfiles [] {
    if $nu.os-info.name == "windows" {
        cd ~\repos\dotfiles\
    } else if $nu.os-info.name == "linux" {
        cd ~/repos/dotfiles/
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    nvim .
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
    nvim .
}

# cd into AppData/local/nvim/lua/custom && nvim .
export def --env vimrc [] {
    if $nu.os-info.name == "windows" {
        cd ~\AppData\Local\nvim\lua\custom
        nvim .
    } else {
        cd ~/repos/dotfiles/.config/preconfigured-nvim/kickstart.nvim/
        nvim init.lua
    }
}

# cd into repos/dotfiles/.config/.espanso && code .
export def --env espanso [] {
    if $nu.os-info.name == "windows" {
        cd ~\repos\dotfiles\.config\.espanso
    } else if $nu.os-info.name == "linux" {
        cd ~/repos/dotfiles/.config/.espanso
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    nvim .
}
