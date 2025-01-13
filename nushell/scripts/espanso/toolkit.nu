export def build [] {
    print "📦 building the binary"
    print "     [x] Wayland"
    print "     [x] Debug"
    print "     [x] Binary"

    cargo make build-binary
}

export def --env test [] {
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
