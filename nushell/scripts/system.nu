
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
        print "updating scoop..."
        scoop update --all
    } else if $nu.os-info.name == "linux" {
        error make {msg: "not implemented" }
    } else {
        error make {msg: "Could not find the OS name :(", }
    }
    print "rustup update..."
    # cross platform commands
    rustup update
}
