export module "check pr" {
    export def "espanso" [] {
        print " running cargo check"
        cargo check
        print " running cargo build"
        cargo build
        print " running cargo test"
        cargo test
    }

    export def "nushell" [] {
        print "you already have toolkit.nu!"
    }
}