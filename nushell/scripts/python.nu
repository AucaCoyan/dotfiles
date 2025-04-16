# Deprecated: Create a new workspace with `rye` (unexported)
def --env new [folder: string] {
    print " 📁 creating folder"

    if ($folder | path exists) {
        error make {msg: $" 📂 ($folder) folder exists"
            help: "I can only create new project on non-existing folders"
        }
    }
    ^rye init $folder

    print " 📂 cd into it..."
    cd $folder
    # nushell is not cd'ing into the $folder
    ^rye add --dev pytest

    ^rye sync

}
