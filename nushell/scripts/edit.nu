# cd into repos/dotfiles && $EDITOR .
export def --env dotfiles [] {
    if $nu.os-info.name == "windows" {
        cd ~\repos\dotfiles\
    } else {
        cd ~/repos/dotfiles/
    }
    nvim .
}


# cd into repos/dotfiles && code . --profile nushell
export def --env nushell [] {
    if $nu.os-info.name == "windows" {
        cd ~\repos\dotfiles\nushell\
    } else {
        cd ~/repos/dotfiles/nushell/
    }
    code . --profile nushell
}


# cd into ~\other-repos\nu\nu_scripts\ && code .
export def --env nu_scripts [] {
    if $nu.os-info.name == "windows" {
        cd ~\other-repos\nu\nu_scripts\
    } else {
        cd ~/other-repos/nu/nu_scripts/
    }
    code .
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
    } else {
        cd ~/repos/dotfiles/.config/.espanso
    }
    nvim .
}
