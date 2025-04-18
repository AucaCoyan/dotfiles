export def "espanso build-deb" [] {

    let script = r#'
#!/bin/bash

set -e

echo "Installing cargo-deb"
# cargo install cargo-deb
cargo install cargo-deb --version 1.44.1

# echo "Building X11 deb package"
# cargo deb -p espanso -- --no-default-features --features "modulo vendored-tls"

echo "Building Wayland deb package"
cargo deb -p espanso --variant wayland -- --no-default-features --features "modulo wayland vendored-tls"

# cd ..
cp target/debian/espanso*.deb espanso-debian-x11-amd64.deb
# sha256sum espanso-debian-x11-amd64.deb > espanso-debian-x11-amd64-sha256.txt
cp target/debian/espanso-wayland*.deb espanso-debian-wayland-amd64.deb
# sha256sum espanso-debian-wayland-amd64.deb > espanso-debian-wayland-amd64-sha256.txt
# ls -la

# echo "Copying to mounted volume"
# cp espanso-debian-* /shared

echo "  Done!"
    '#

    print "running: "
    print $script

    print "..."

    bash -c $script
}
