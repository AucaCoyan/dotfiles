# pulls every repo on ~/repos/ and ~/other-repos/
export def git-multi-pull2 [] {
    let repos_list = (ls ~/repos/ )
    let other_repos_list = (ls ~/other-repos/)

    $repos_list.name | each { |repo| 
        print -n $"fetching ($repo)\n"
        cd $repo
        git fetch
    }

    $other_repos_list.name | each { |repo| 
        print -n $"fetching ($repo)\n"
        cd $repo
        git fetch
    }
}
