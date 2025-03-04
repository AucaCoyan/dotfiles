# Scripts for developing espanso
# using nushell, you can source this file as:
#
# $ use ~/path/to/this/script/toolkit.nu
#
# and then you can call
#
# toolkit build
# toolkit test
# toolkit clean
# and so on...

const ESPANSO_DEV_FOLDER = "~/repos/espanso/"

# build the binary
export def --env build [] {
    cd $ESPANSO_DEV_FOLDER
    print "📦 building the binary"
    print "     [x] Wayland"
    print "     [x] Release"
    print "     [x] build-binary"

    if $nu.os-info.name == "windows" {
        # cargo make build-binary
        cargo make --profile release --env NO_X11=true build-binary
    } else if $nu.os-info.name == "linux" {
        cargo make --profile release --env NO_X11=true build-binary

    } else if $nu.os-info.name == "macos" {
        # cargo make --profile release --env NO_X11=true build-binary
        cargo make --profile release -- create-bundle
    }
}

export def --env test [] {
    cd $ESPANSO_DEV_FOLDER
    cd ./target/release/

    if $nu.os-info.name == "linux" {
        # set capabilities
        # sudo setcap "cap_dac_override+p" ./espanso

        print "`espanso service register`..."
        ./espanso service register
    }

    print "`espanso start`"
    ./espanso start
}

export def clean [] {
    print "Removing the espanso.service"
    # remove the service
    rm ~/.config/systemd/user/espanso.*

    print "Done!"
}

export def "act run" [] {
    act workflow_dispatch
}

# deletes the tag and re-tags it again in the `origin` remote
export def "tag-again" [] {
    # TODO: pass the version as a variable
    git tag -d v2.2.2
    git push --delete origin v2.2.2
    git tag v2.2.2
    git push origin v2.2.2
}
