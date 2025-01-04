
# zig
sudo mkdir -p /usr/local/bin/

if $nu.os-name == 'macos' {
    # just any random day
    const day = 'v2025_01_02'
    curl -L $"https://github.com/marler8997/zigup/releases/download/($day)/zigup-aarch64-macos.tar.gz" | tar xz
    sudo mkdir -p /usr/local/bin/
    sudo /usr/local/bin/zigup master
    rm ./zigup
}


