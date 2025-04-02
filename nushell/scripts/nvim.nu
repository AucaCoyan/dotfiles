export def rm_nvim_dirs [] {
    if $nu.os-info.name == "windows" {
        print "🔥 Removing `/nvim` and `/nvim-data` "

        let path = [$env.home, "/AppData/Local/nvim-data" ] | str join
        if ( $path | path exists) {
            rm $path --recursive
        }
        let path = [$env.home, "/AppData/Local/nvim" ] | str join
        if ( $path | path exists) {
            rm $path --recursive
        }

        print "🔗 Making the symlinks"

        pwsh -c 'New-Item -type junction -Path "$HOME\AppData\Local\nvim" -Target $HOME\repos\dotfiles\.config\nvim'

        print "✅ Job's done!"
    } else if $nu.os-info.name == "linux" {
        # binary
        rm /usr/local/bin/nvim
        # temp folder
        rm ~/.local/share/nvim/ --recursive
        # symlink
        rm ~/.config/nvim
    } else if $nu.os-info.name == "macos" {
    error make {msg: "not implemented!", }
    }
}

export def download_nvim [] {
    print "Downloading nvim"

    if $nu.os-info.name == "windows" {
        error make {msg: "not implemented!", }
    } else if $nu.os-info.name == "linux" {
        let tag_name = gh api /repos/neovim/neovim/releases/latest | from json | get tag_name

        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        gh api /repos/neovim/neovim/releases/latest
        | from json
        | get tarball_url
        | curl -L $in
        | save "neovim-latest.tar.gz"

        tar xpvf neovim-latest.tar.gz
        rm neovim-latest.tar.gz

        let folder_name = ls neovim-* | get name | first
        #cp $"(folder_name)/"

    }
}

export def "install personal" [] {
    rm_nvim_dirs
    if $nu.os-info.name == "windows" {
        error make {msg: "not implemented!", }
    } else if $nu.os-info.name == "linux" {
        download_nvim

        ## Clipboard for lazyVim
        sudo nala install xclip -y

        print "creating the symlink"
        ln -s ~/repos/dotfiles/.config/nvim ~/.config/nvim
    }
}

