export def list_scoop_packages [] {
    (
    scoop export 
        | from json             # convert raw input to json
        | get apps              # get only the key "apps"
        | select Name Version   # select the columns Name and Version
      # | to json               # transform it to json
    )

    # save "current-scoop-pkgs.txt"  # save to txt file

# alternative
#  open scoop-list.json | get 'apps' | select Name | to text | save "1.txt"
# scoop export | from json | get apps | select Name | to text | save "2.txt"
}

# cd into appdata/local/nvim/lua/custom && nvim .
export def editvimrc [] {
    cd ~\AppData\Local\nvim\lua\custom
    nvim .
}

# cd into repos/dotfiles && code .
export def editdot [] {
    cd ~\repos\dotfiles\
    code .
}

export def user-profile-path [] {
    [
        $env.USERPROFILE,
        "\\repos\\dotfiles\\Powershell\\oh-my-posh.config.json"
    ] 
    | str join
}

export def new-junction [
    name: path               # origin, or folder you want to Symlink
    target: path             # destination, or the folder you want to refer
    ] {
    let command = ([
    "New-Item",
    "-ItemType",
    "Junction",
    "-Path",
    $name,
    "-Target",
    $target
    ] |
    str join 
    ' '     # add this separator to join with spaces 
    )
    echo $command
    pwsh -Command $command
}

# export def git-gone [] {
#     git branch --merged 
#     | lines 
#     | where $it !~ '\*' 
#     | str trim 
#     | where $it != 'master' and $it != 'main' 
#     | each {
#          |it| git branch -d $it 
#          }
# }
