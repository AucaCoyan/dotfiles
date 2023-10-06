
export def git-pull-mule-repos [] {
    let workspace_list = (ls ~/workspace/digital*)

    $workspace_list.name | each { |repo| 
        print -n $"fetching ($repo)\n"
        cd $repo
        git pull origin HEAD
    }
}