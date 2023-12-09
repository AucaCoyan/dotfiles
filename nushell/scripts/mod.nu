export use git-multi-fetch-workspace.nu *
export use git-multi-pull.nu * 
export use git-multi-fetch-workspace.nu *

# updates the fork based on `main` branch of the remote `upstream`
export def update-the-fork [] {
    print "⏬ fething upstream"
    #TODO check if `upstream` is in the list of remotes
    # ^git remote
    # | lines
    ^git fetch upstream
    print "\n✔ checking out main"
    ^git checkout main
    # ^git checkout master
    print "\n💫 rebasing from upstream/main"
    git rebase upstream/main
}