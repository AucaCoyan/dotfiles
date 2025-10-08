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
        # direct downlaod
        # curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip

        # scoop
        scoop install neovim

    } else if $nu.os-info.name == "linux" {
        # from https://github.com/nvim-lua/kickstart.nvim
        # sudo apt update
        # sudo apt install make gcc ripgrep unzip git xclip curl

        # Now we install nvim
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo mkdir -p /opt/nvim-linux-x86_64
        sudo chmod a+rX /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

        # make it available in /usr/local/bin, distro installs to /usr/bin

    } else if $nu.os-info.name == "macos" {
        error make {msg: "not implemented!", }
    }
}

export def "install personal" [] {
    rm_nvim_dirs
    if $nu.os-info.name == "windows" {
        download_nvim

        print "🔗 Making the symlinks"
        pwsh -c 'New-Item -type junction -Path "$HOME\AppData\Local\nvim" -Target $HOME\repos\dotfiles\.config\nvim'
    } else if $nu.os-info.name == "linux" {
        download_nvim

        ## Clipboard for lazyVim
        # sudo nala install xclip -y

        print "🔗 Making the symlinks"
        sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/

        ln -s ~/repos/dotfiles/.config/nvim ~/.config/nvim
    }
    nvim
}

export def "install kickstart" [] {
    rm_nvim_dirs
    if $nu.os-info.name == "windows" {
        download_nvim

        # or directly clone into AppData
        # git clone https://github.com/nvim-lua/kickstart.nvim.git $"($env.LOCALAPPDATA)/nvim"

        print "🔗 Making the symlinks"
        pwsh -c 'New-Item -type junction -Path "$HOME\AppData\Local\nvim-kickstart" -Target $HOME\repos\dotfiles\.config\preconfigured-nvim\kickstart.nvim'
    } else if $nu.os-info.name == "linux" {
        error make {msg: "not implemented!", }

        download_nvim

        # ## Clipboard for lazyVim
        # sudo nala install xclip -y

        print "🔗 Making the symlinks"
        ln -s ~/repos/dotfiles/.config/preconfigured-nvim/kickstart.nvim ~/.config/nvim
    }
    nvim
}

export def "install nvchad" [] {
    rm_nvim_dirs
    if $nu.os-info.name == "windows" {
        download_nvim

        pwsh -c 'New-Item -type junction -Path "$HOME\AppData\Local\nvim" -Target $HOME\repos\dotfiles\.config\preconfigured-nvim\NvChad'
    } else if $nu.os-info.name == "linux" {
        error make {msg: "not implemented!", }

        # download_nvim
        #
        # ## Clipboard for lazyVim
        # sudo nala install xclip -y
        #
        # print "creating the symlink"
        # ln -s ~/repos/dotfiles/.config/nvim ~/.config/nvim
    }
    nvim
}
