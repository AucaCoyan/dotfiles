#! /bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Written by @AamnahAkram from http://aamnah.com
#######################################

set -eu -o pipefail # fail on error and report it, debug all lines

# setup dark theme in Debian
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

echo -e "###### Linux installation script ######"

## Update packages and Upgrade system
echo -e "\n### Updating the system"
sudo apt-get update -y

# `git`
echo -e '\n### `git`'
sudo apt-get install git -y

# Git Configuration
echo -e '\n### Configure git'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
echo -e 'Git has been configured!'
# git config --list

# `curl`
echo -e '\n### `curl`'
sudo apt install curl -y

# `gh` CLI
echo -e '\n### `gh`'
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt install gh -y

# Brew
echo -e '\n### `brew`'
# || is an OR operator. Sends the command only if the first part gave an error
# forward to /dev/null to bypass the "Press enter to continue" step
type -p brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
## some brew dependencies / recommended pkgs
sudo apt-get install build-essential
brew install gcc
## add brew to path
echo -e '\n### Adding `brew` to PATH'
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# `nushell`
echo -e '\n### Install nushell'
brew install nushell

# repos and other-repos folders
echo -e '\n### create ~/repos/'
mkdir --parents ~/repos
echo -e '\n### cloning dotfiles'
if [ ! -d ~/repos/dotfiles ]; then
    git clone https://github.com/AucaCoyan/dotfiles ~/repos/dotfiles
else
    echo -e '\n ~/repos/doftiles found. Skipping!'
fi

echo -e '\n### create ~/other-repos/'
mkdir --parents ~/other-repos
echo -e '\n### cloning nu_scripts'
if [ ! -d ~/other-repos/nu/nu_scripts ]; then
    git clone https://github.com/nushell/nu_scripts ~/other-repos/nu/nu_scripts
else
    echo -e '\n ~/other-repos/nu/nu_scripts found. Skipping!'
fi

echo -e '\n### cloning nupm'
if [ ! -d ~/other-repos/nupm ]; then
    git clone https://github.com/nushell/nupm ~/other-repos/nupm
else
    echo -e '\n ~/other-repos/nu/nupm found. Skipping!'
fi

echo -e '\n### making a symlink to ~/repos/dotfiles/nushell'
ln -s ~/repos/dotfiles/nushell ~/.config/nushell

echo -e '\n### `bat`'
sudo apt install bat
echo -e '\n### symlinking batcat to bat because of the name collition'
mkdir --parents ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

echo -e '\n### `ripgrep`'
brew install ripgrep

## install oh-my-posh
echo -e '\n### `oh-my-posh`'
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# install `FiraCode`
echo -e '\nInstalling Font FiraCode'
mkdir --parents ~/.local/share/fonts
cd ~/.local/share/fonts
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz
# unzip
tar xf FiraCode.tar.xz

#reload the fonts
echo -e '...reloading the fonts cache'
fc-cache

# Rust
echo -e '\n### Rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo -e '\n### Reloading cargo env'
source "$HOME/.cargo/env"

# fnm (node & npm)
echo -e '\n### `fnm`'
curl -fsSL https://fnm.vercel.app/install | bash

# VS Code
echo -e '\n### VS Code'
wget https://code.visu lstudio.com/sha/download?build=stable&os=linux-deb-x64 --output-document=vscode-stable-x64-linux.deb
sudo apt install ./vscode-stable-x64-linux.deb

# Clean up
echo -e '\n### Clean up'
apt autoremove -y
