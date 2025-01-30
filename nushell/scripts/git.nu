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

export def gone [] {
    git branch --merged 
    | lines 
    | where $it !~ '\*' 
    | str trim 
    | where $it != 'master' and $it != 'main' 
    | each {
         |it| git branch -d $it 
         }
}

# updates the fork based on `main` branch of the remote `upstream`
export def "update-the-fork" [branch?: string = "main"] {
    print "⏬ fething upstream"
    #TODO check if `upstream` is in the list of remotes
    # ^git remote
    # | lines
    ^git fetch upstream
    print $"\n✔  done\n🏁 checking out ($branch)"
    ^git checkout $branch
    print $"\n✔  done\n💫 rebasing from upstream/($branch)"
    git rebase $"upstream/($branch)"
}

# <repo: > fork the repo and clones it on ~/repos/
export def --env "fork this" [ghrepo:string] {
    cd ~/repos
    print "⏬ fork + clone the repo"
    ^gh repo fork $ghrepo --clone --default-branch-only
    let folder = gh repo view $ghrepo --json name | from json | get name
    cd $"~/repos/($folder)"
}

export def "git branch clean" [] {
    print "running git fetch --prune"
    git fetch --prune
    print $"\n✔  done"
}

# git comes with a lot of old default configs. This helper function does some
# better defaults to my preference
#
# based on: [so you think you know git](https://www.youtube.com/watch?v=aolI_Rz0ZqY)
def better_default_config [] {
    # `git stash --all` also stash untracked files
    git config --global alias.staash 'stash --all'
}
