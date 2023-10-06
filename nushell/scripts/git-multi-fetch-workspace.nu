
# git pull on ~/workspace/ repos
export def pull-workspace-repos [] {
    let workspace_list = (ls ~/workspace/)

    $workspace_list.name | each { |repo| 
        print -n $"pulling ($repo)\n"
        cd $repo
        git pull
    }
}
