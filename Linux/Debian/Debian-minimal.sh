#! /bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines


echo -e "###### Linux installation script ######"

## Update packages and Upgrade system
echo -e "\n### Updating the system"
sudo apt-get update -y

echo -e "\n### Install nala"
sudo apt-get install nala -y

# `git`
echo -e '\n### `git`'
sudo apt-get install git -y

# Git Configuration
echo -e '\n### Configure git'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
# set `git push` to automatically setup the remote branch (no need to --set-upstream-to=)
git config --global --add --bool push.autoSetupRemote true
echo -e 'Git has been configured!'
# git config --list

# `curl`
echo -e '\n### `curl`'
sudo apt install curl -y

# # `gh` CLI
# echo -e '\n### `gh`'
# curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
# && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
# && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
# && sudo apt install gh -y

# repos and other-repos folders
echo -e '\n### create ~/repos/'
mkdir --parents ~/repos
echo -e '\n### cloning dotfiles'
if [ ! -d ~/repos/dotfiles ]; then
    git clone https://github.com/AucaCoyan/dotfiles ~/repos/dotfiles
else
    echo -e '\n ~/repos/doftiles found. Skipping!'
fi

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

# rust tools
echo -e '\n### cargo-binstall'
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

echo -e '\n### cargo-update'
cargo binstall cargo-update

# Clean up
echo -e '\n### Clean up'
sudo apt autoremove -y
