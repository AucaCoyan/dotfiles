#! /bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Written by @AamnahAkram from http://aamnah.com
#######################################

set -eu -o pipefail # fail on error and report it, debug all lines

echo -e "###### Linux installation script ######"

## Update packages and Upgrade system
echo -e "\nUpdating the system"
sudo apt-get update -y

## `git` ##
echo -e '\n###Installing Git..'
sudo apt-get install git -y

# Git Configuration
echo -e '\n ###Congigure Git..'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
echo -e 'Git has been configured!'
# git config --list

# `curl`
echo -e '\n Installing `curl`'
sudo apt install curl -y

## Brew ##
echo -e '\n ###Installing Brew'
# forward to /dev/null to bypass the "Press enter to continue" step
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
# add brew to path
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## install oh-my-posh
echo -e '\n Installing `oh-my-posh`'
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# install `FiraCode`
echo -e '\n Installing Font FiraCode'
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz
# unzip
tar xf FiraCode.tar.xz

#reload the fonts
echo -e '...reloading the fonts cache'
fc-cache

# Rust
echo -e '\n ### Installing Rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# fnm (node & npm)
echo -e '\n Installing `fnm`'
curl -fsSL https://fnm.vercel.app/install | bash
