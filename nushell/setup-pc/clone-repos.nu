# clone important repos I use often
export def clone-repos [] {

}


export def clone-work-repo [...repos] {
    $repos | par-each { |repo|
        let path = ("~/repos/" | path join $repo)
        if ($path | path expand | path exists) {
            cd $path
            git pull --all --ff
        } else {
            git clone --recursive $"git@github.com:work_org/($repo).git" $path
            cd $path
            [ master release develop ] | each { git checkout $in }
        }

        if $repo == 'specific_work_repo' {
            # this repo has symlinks that 'cp -c' will mangle, so it needs
            # to be special-cased
            ^cp -r $path ./
        } else {
            if $nu.os-info.name == "macos" {
                # need to use /bin/cp in order to get reflink in APFS
                /bin/cp -r -c $path ./
            } else {
                ^cp -r --reflink=auto $path ./
            }
        }
    }
}
