
# cleans the cache and others temp files in the system 
export def "clean" [] {
    if $nu.os-info.name == "windows" {
        print "cleaning scoop cache..."
        scoop cleanup --all

    } else if $nu.os-info.name == "linux" {
        print "cleaning apt cache..."
        sudo nala clean

        print "nala autoremove"
        sudo nala autoremove
        print "nala autopurge"
        sudo nala autopurge
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    # cross platform commands

    # clean the Temp folder
    print "cleaning TMP folder"
    ls $env.TEMP | par-each {|item| rm $item.name --recursive}

    print "cleaning uv"
    uv cache prune
    # TODO: This removes any stopped container
    # so if you stopped your db just for some reason,
    # it throws away the data
    # docker system prune --all
    # including
    # - all stopped containers
    # - all networks not used by at least one container
    # - all dangling images
    # - unused build cache
}


# updates the system
export def "update" [] {
    if $nu.os-info.name == "windows" {
        print "💫 updating scoop..."
        scoop update --all

    } else if $nu.os-info.name == "linux" {
        print "💫 updating apt"
        sudo nala upgrade # updates the pkgs and then upgrades the system

        print "💫 updating brew"
        brew update
        brew upgrade

    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    print "💫 rustup update..."
    # cross platform commands
    rustup update

    print "💫 bun update..."
    bun upgrade

    print "💫 uv update..."
    uv self update

    print "💫 rye update..."
    rye self update

    print "💫 cargo-update..."
    cargo install-update --all

    print "💫 updating broot"
    broot --print-shell-function nushell
    | save $"($env.home)/repos/dotfiles/nushell/cfg_files/broot.nu" --force

    print "✅ done!"
}

