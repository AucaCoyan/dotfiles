
# cleans the cache and others temp files in the system 
export def "clean" [] {
    if $nu.os-info.name == "windows" {
        print "cleaning scoop cache..."
        scoop cleanup --all --cache

        # TODO: close spotify
        print "cleaning Spotify cache"
        let SPOTIFY_TEMP_FOLDER = $"($env.LOCALAPPDATA)/Spotify/Storage"
        rm $SPOTIFY_TEMP_FOLDER --recursive --permanent
        # TODO: show how much mb were deleted
        # TODO: open spotify again!

    } else if $nu.os-info.name == "linux" {
        print "cleaning apt cache..."
        sudo nala clean

        print "nala autoremove"
        sudo nala autoremove
        print "nala autopurge"
        sudo nala autopurge

        let SPOTIFY_TEMP_FOLDER = "~/.cache/spotify/Storage/"
        # rm $SPOTIFY_TEMP_FOLDER --recursive --permanent

    } else {
        let SPOTIFY_TEMP_FOLDER = "OS X: /Users/USERNAME/Library/Caches/com.spotify.client/Storage/"
        error make {msg: "Could not find the OS name :(", }
    }
    # cross platform commands

    # clean the Temp folder
    print "cleaning TMP folder"
    # needs admin access in windows
    # ls $env.TEMP | par-each {|item| rm $item.name --recursive}

    print "cleaning uv"
    uv cache prune

    print "cleaning npm cache"
    npm cache clean --force

    print "cleaning bun cache"
    bun pm cache rm -g
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

    # print "💫 flutter upgrade..."
    # flutter upgrade
    print "✅ done!"
}

