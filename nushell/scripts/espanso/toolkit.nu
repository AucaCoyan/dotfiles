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

const ESPANSO_DEV_FOLDER = "~/repos/fix-unable-to-start-espanso/"

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

# tests whatever workflow you want to test (issue repro, cargo test, whatever)
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

# commands to clean the state to be able to test again
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

# signs the executable in macOS
#
# [source](https://stackoverflow.com/questions/69354021/how-do-i-go-about-code-signing-a-macos-application)
export def --env sign [] {
    cd $ESPANSO_DEV_FOLDER

    print " Signing the app ./target/mac/Espanso.app..."
    codesign -f -o runtime --timestamp -s "Developer ID Application: Auca Coyan Maillot (6424323YUH)" ./target/mac/Espanso.app

    print " Notarizing the app"

    # TODO: check if `espanso.dmg` exists
    print " Creating a disk image"
    hdiutil create -srcfolder ./target/mac/Espanso.app -volname Espanso.app Espanso

    # upload the disk image to notary service
    # it doesn't work
    # xcrun altool --notarize-app --primary-bundle-id "<your identifier>" -u "<your email>" -p "<app-specific pwd>" -t osx -f /path/to/MyApp.dmg
}
