# Scripts for developing espanso
# using nushell, you can source this file as:
#
# $ use ~/path/to/this/script/toolkit.nu
#
# ...and then you can call
#
# toolkit build
# toolkit test
# toolkit clean
# etc...

# build the binary
export def --env build [] {
    print " running cargo build"
    if $nu.os-info.name == "windows" {
        # cargo make build-binary
        cargo build
    } else if $nu.os-info.name == "linux" {
        cargo build --no-default-features --features modulo,vendored-tls,wayland
    } else if $nu.os-info.name == "macos" {
        cargo build --target aarch64-apple-darwin
        cargo build --target x86_64-apple-darwin
    }
}

# tests whatever workflow you want to test (issue repro, cargo test, whatever)
export def --env try [] {
    cd $env.ESPANSO_DEV_FOLDER
    print " ---------- creating AppImage ---------- "
    cargo make --profile release -- create-app-image
    cd ./target/linux/AppImage/out

    print " ---------- runnin AppImage ---------- "
    ./Espanso-x86_64.AppImage

    # cd ./target/release/

    if $nu.os-info.name == "linux" {
        # set capabilities
        # sudo setcap "cap_dac_override+p" ./espanso

        # print "`espanso service register`..."
        # ./espanso service register
    }

    # print "`espanso start`"
    # ./espanso start
}

# commands to clean the state to be able to test again
export def clean [] {
    if $nu.os-info.name == "linux" {
        # remove the service
        print "🔥 Removing the espanso.service..."
        if ('~/.config/systemd/user/espanso.service' | path exists) {
            rm ~/.config/systemd/user/espanso.*
        }
    }

    print "🔥 running cargo clean..."
    cargo clean

    # uninstall espanso*.deb
    # sudo dpkg --remove espanso
    print "✅ Done!"
}

export def "act run" [] {
    act workflow_dispatch
}

# tags the current commit locally and in the `origin` remote
export def "tag-commit" [tag: string] {
    git tag $tag
    git push origin $tag
}

# signs the executable in macOS
#
# [source](https://stackoverflow.com/questions/69354021/how-do-i-go-about-code-signing-a-macos-application)
export def --env sign [] {
    cd $env.ESPANSO_DEV_FOLDER

    if $nu.os-info.name == "windows" {
        print "\n ⛏  building the resources"
        cargo make --profile release -- build-windows-resources

        print "\n ✍  signing the resources"
        cargo make sign-windows-resources

        print "\n ⛏  building the installer"
        cargo make --profile release --skip-tasks build-windows-resources -- build-windows-installer

        print "\n ✍  Signing the app"
        cargo make sign-windows-installer

        print "\n ⛏  building the portable"
        cargo make --profile release --skip-tasks build-windows-resources -- build-windows-portable

        pwsh -c "Rename-Item target/windows/portable espanso-portable
          Compress-Archive target/windows/espanso-portable target/windows/Espanso-Win-Portable-x86_64.zip"

        pwsh -c "Get-FileHash target/windows/Espanso-Win-Portable-x86_64.zip -Algorithm SHA256 | select-object -ExpandProperty Hash > target/windows/Espanso-Win-Portable-x86_64.zip.sha256.txt
          Get-FileHash target/windows/installer/Espanso-Win-Installer-x86_64.exe -Algorithm SHA256 | select-object -ExpandProperty Hash > target/windows/installer/Espanso-Win-Installer-x86_64.exe.sha256.txt"
    } else if $nu.os-info.name == "linux" {

    } else if $nu.os-info.name == "macos" {
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
}

# returns "wayland" or "x11"
#
# If the above command doesn't output anything, please try with this method.
# https://unix.stackexchange.com/a/325972
export def "check-desktop-environment" [] {
    if $nu.os-info.name == "windows" {
        error make {msg: $"Not usable in Windows", }
    } else if $nu.os-info.name == "linux" {
        return $env.XDG_SESSION_TYPE
    } else if $nu.os-info.name == "macos" {
        error make {msg: $"Not usable in macOS", }
    }
}

export def "check-pr" [] {
    print " checking format"
    cargo fmt --all --check

    build

    print " running cargo clippy"
    # --locked is for prevent updating the cargo.lock file
    # is for any situation in which you don't want to update the deps.
    if $nu.os-info.name == "windows" {
        cargo clippy -- -D warnings
    } else if $nu.os-info.name == "linux" {
        bash -c 'cargo clippy --target=x86_64-unknown-linux-gnu -- --deny warnings'
    } else {
        cargo clippy --target=aarch64-apple-darwin -- --deny warnings
        cargo clippy --target=x86_64-apple-darwin -- --deny warnings
    }

    test
}

export def "test" [] {
    print " running cargo test"
    cargo test --workspace --exclude espanso-modulo --exclude espanso-ipc --no-default-features --features vendored-tls
}

export module package {
    # builds the .deb package and if you like, reinstalls it
    #
    # run with `toolkit package-deb reinstall true
    export def "build-deb" [--reinstall = false] {
        if $nu.os-info.name == "windows" {
            error make {msg: $"Not usable in Windows", }
        } else if $nu.os-info.name == "linux" {
            let my_var = check-desktop-environment
            if $my_var == "wayland" {
                echo "Building Wayland deb package"
                cargo deb --verbose --package espanso --variant wayland -- --no-default-features --features "modulo wayland vendored-tls"
            } else {
                echo "Building X11 deb package"
                cargo deb --verbose --package espanso -- --no-default-features --features "modulo vendored-tls"
            }
        } else if $nu.os-info.name == "macos" {
            error make {msg: $"Not usable in macOS", }
        }

        if $reinstall {
            sudo dpkg --remove espanso
            chmod +x ./target/debian/espanso*.deb
            sudo dpkg --install ./target/debian/espanso*.deb
        }

    }

    # TODO
    # export def "build-fedora" [] {
    #     error make {msg: $"Not implemented", }
    # }

    # builds the AppImage
    export def "build-appimage" [] {
        if $nu.os-info.name == "linux" {
            cargo make --profile release -- create-app-image
        } else {
        error make {msg: $"Not implemented", }
        }
    }

} # package module

# makes the symlink between the config folder and dotfiles/.espanso
export def "make symlink" [] {
    print "🔗 creating the symlink"

    print "Checking if espanso is running"
    let espanso_proceses = (ps | where name =~ 'espanso*' | length)
    if ($espanso_proceses > 0) {
        print "Yup, stopping espanso"
        espanso stop
    }

    # TODO: Ask for confirmation of deletion of the folder

    if $nu.os-info.name == "windows" {
        let path = [$env.home, "/AppData/Roaming/espanso/" ] | str join
        if ( $path | path exists) {
            rm $path --recursive
        }
        pwsh -c 'New-Item -type junction -Path "$HOME\AppData\Roaming\espanso\" -Target $HOME\repos\dotfiles\.config\.espanso\'
    } else if $nu.os-info.name == "linux" {
        error make {msg: "not implemented!", }
        ln -s ~/repos/dotfiles/.config/.espanso  ~/.config/espanso
    } else {
        error make {msg: "not implemented!", }
    }
    print "✅ Done!"
}
