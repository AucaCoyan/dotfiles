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
    print "     [x] Debug"
    print "     [x] Binary"

    cargo make build-binary
}

export def --env test [] {
    cd $ESPANSO_DEV_FOLDER
    cd ./target/debug/

    # set capabilities
    # sudo setcap "cap_dac_override+p" ./espanso
    
    print "`espanso service register`..."
    ./espanso service register

    print "`espanso start`"
    ./espanso start
}

export def clean [] {
    print "Removing the espanso.service"
    # remove the service
    rm ~/.config/systemd/user/espanso.*

    print "Done!"
}
