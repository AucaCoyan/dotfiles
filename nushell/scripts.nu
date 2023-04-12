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

export def editvimrc [] {
    cd ~\AppData\Local\nvim\lua\custom
    nvim .
}

export def user-profile-path [] {
    [$env.USERPROFILE, "\\repos\\dotfiles\\Powershell\\oh-my-posh.config.json"] | str join
}