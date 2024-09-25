export def "install personal" [] {
    if $nu.os-info.name == "windows" {
        error make {msg: "not implemented!", }
    } else if $nu.os-info.name == "linux" {
        print "creating the symlink"
        ln -s ~/repos/dotfiles/.config/nvim ~/.config/nvim
    }
}