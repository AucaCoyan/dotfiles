# returns the top lines of `git status`
export def summary [] {
    git status | str replace --regex --multiline '\n\n[\s\S]*' ''
}

# pulls every repo on ~/workspace/
export def "multi pull-workspace-repos" [] {
    let workspace_list = (ls ~/workspace/)

    $workspace_list.name | each { |repo| 
        print -n $"pulling ($repo)\n"
        cd $repo
        git pull
    }
}

# pulls every repo on ~/repos/ and ~/other-repos/
export def "multi pull" [] {
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

# pulls every repo on ~/workspace/digital*
export def "multi pull-mule-repos" [] {
    let workspace_list = (ls ~/workspace/digital*)

    $workspace_list.name | each { |repo| 
        print -n $"fetching ($repo)\n"
        cd $repo
        git pull origin HEAD
    }
}
