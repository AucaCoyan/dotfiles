#! /bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Written by @AamnahAkram from http://aamnah.com
#######################################

set -eu -o pipefail # fail on error and report it, debug all lines

echo -e "###### Linux installation script ######"

## Update packages and Upgrade system
echo -e "\n### Updating the system"
sudo apt-get update -y

# `git`
echo -e '\n### Installing Git..'
sudo apt-get install git -y

# Git Configuration
echo -e '\n### Configure Git..'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
echo -e 'Git has been configured!'
# git config --list

# `curl`
echo -e '\n### `curl`'
sudo apt install curl -y

# Brew
echo -e '\n### `brew`'
# forward to /dev/null to bypass the "Press enter to continue" step
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
## some brew dependencies / recommended pkgs
sudo apt-get install build-essential
brew install gcc
## add brew to path
echo -e '\n### Adding `brew` to PATH'
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# `nushell`
brew install nushell

mkdir ~/repos
git clone https://github.com/AucaCoyan/dotfiles ~/repos/dotfiles

mkdir ~/other-repos
git clone https://github.com/nushell/nupm ~/other-repos/nupm
git clone https://github.com/nushell/nu_scripts ~/other-repos/nu/nu_scripts

ln -s ~/repos/dotfiles/nushell ~/.config/nushell

brew install ripgrep

## install oh-my-posh
echo -e '\n### `oh-my-posh`'
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# install `FiraCode`
echo -e '\nInstalling Font FiraCode'
mkdir -p ~/.local/share/fonts
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
