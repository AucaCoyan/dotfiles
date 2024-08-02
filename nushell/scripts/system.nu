
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
}