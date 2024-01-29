#! /bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Written by @AamnahAkram from http://aamnah.com
#######################################

set -eu -o pipefail # fail on error and report it, debug all lines

echo "###### Linux installation script ######"

## Update packages and Upgrade system
sudo apt-get update -y

## `git` ##
echo '###Installing Git..'
sudo apt-get install git -y

# Git Configuration
echo '###Congigure Git..'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
echo 'Git has been configured!'
# git config --list

# `curl`
sudo apt install curl -y

## Brew ##
echo '###Installing Brew'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# add brew to path
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## install oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# install `FiraCode`
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz
# unzip
tar xf FiraCode.tar.xz

#reload the fonts
fc-cache

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# fnm (node & npm)
curl -fsSL https://fnm.vercel.app/install | bash
