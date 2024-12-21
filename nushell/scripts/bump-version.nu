# script to bump version
export def main [
    --major # This is a major bump v1.0.0
    --minor # This is a minor bump v0.1.0
    --bugfix # This is a bugfix bump v0.0.1
    ] {

    let version = open espanso/Cargo.toml | get package.version

    if $major {
        print $"major version ($version)"
    } else if $minor {
        print $"minor version ($version)"
    } else if $bugfix {
        print $"bugfix version ($version)"
    } else {
        error make {msg: "You have to specify which version to bump," }
    }
}