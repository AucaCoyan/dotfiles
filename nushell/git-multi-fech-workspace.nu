
let workspace_list = (ls ~/workspace/)

$workspace_list.name | each { |repo| 
    print -n $"fetching ($repo)\n"
    cd $repo
    git fetch
}
