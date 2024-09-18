export def "install personal config" [] {
    print "creating the symlink"

    if $nu.os-info.name == "windows" {
        let path = [$env.home, "/AppData/Roaming/helix/" ] | str join
        if ( $path | path exists) {
            rm $path --recursive
        }
        pwsh -c 'New-Item -type junction -Path "$HOME\AppData\Roaming\helix\" -Target $HOME\repos\dotfiles\.config\helix\'
    } else if $nu.os-info.name == "linux" {
        error make {msg: "not implemented!", }
        ln -s ~/repos/dotfiles/.config/helix  ~/.config/helix
    } else {
        error make {msg: "OS not detected!", }
    }
    print "done!"
}