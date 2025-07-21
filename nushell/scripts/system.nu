
# cleans the cache and others temp files in the system
export def "clean" [] {
    if $nu.os-info.name == "windows" {
        print "cleaning scoop cache..."
        scoop cleanup --all --cache

        # clean the Temp folder
        print "cleaning TMP folder"
        ls $env.TEMP | par-each {|item| rm $item.name --recursive --force}

        print "🗑️ Empty recycle bin..."
        pwsh -c "Clear-RecycleBin -DriveLetter C -Force"

        if (ls ~/AppData/Roaming/stremio/stremio-server/stremio-cache/ | is-not-empty) {
            print "🗑️ Cleaning Stremio Cache..."
            rm ~\AppData\Roaming\stremio\stremio-server\stremio-cache\* --recursive
           }

        # Update the Microsoft Store Apps
        # pwsh -c "Get-AppxPackage | ForEach-Object { Add-AppxPackage -Path $_.InstallLocation -Update }"
        # Commented out because it draws a ton of errors

    } else if $nu.os-info.name == "linux" {
        print "cleaning apt cache..."
        sudo nala clean

        print "nala autoremove"
        sudo nala autoremove
        print "nala autopurge"
        sudo nala autopurge

    } else if $nu.os-info.name == "macos" {
        print "on the works..."
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    # cross platform commands

    print "cleaning uv"
    uv cache prune

    if (which ^npm | is-not-empty) {
        print "cleaning npm cache"
        npm cache clean --force
    }

    if (which ^bun | is-not-empty) {
        print "cleaning bun cache"
        bun pm cache rm -g
    }

    # TODO: This removes any stopped container
    # so if you stopped your db just for some reason,
    # it throws away the data
    # docker system prune --all
    # including
    # - all stopped containers
    # - all networks not used by at least one container
    # - all dangling images
    # - unused build cache

    if $nu.os-info.name == "windows" {
        # Clean disk manager
        # c:\windows\SYSTEM32\cleanmgr.exe /dC /verylowdisk /autoclean
    }
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

    } else if $nu.os-info.name == "macos" {
        print "💫 updating brew"
        brew update
        brew upgrade
    } else {
        error make {msg: "Could not find the OS name :(", }
    }

    # cross platform commands
    if (which ^rustup | is-not-empty) {
        print "💫 rustup update..."
        rustup update
    }

    if (which ^bun | is-not-empty) {
        print "💫 bun update..."
        bun upgrade
    }

    if (which ^uv | is-not-empty) {
        print "💫 uv update..."
        uv self update
    }

    # TODO: breaks `cargo-make` and cargo-update is unable to freeze one
    # crate, so I'm freezing all.
    # if ((which ^cargo | is-not-empty) and (cargo install-update | $env.LAST_EXIT_CODE == 1)) {
        # print "💫 cargo-update..."
        # cargo install-update --all
    # }


    # print "💫 flutter upgrade..."
    # flutter upgrade

    print "⏬ updating dotfiles..."
    git -C  $"($env.Home)/repos/dotfiles" pull
    print "✅ dotfiles done!"
    print "⏬ updating nu_scripts..."
    git -C  $"($env.Home)/other-repos/nu/nu_scripts" pull
    print "✅ nu_scipts done!"
    # git -C  $"($env.Home)/other-repos/nupm" pull
    # print "✅ nupm done!"

    print "✅ done!"
}
