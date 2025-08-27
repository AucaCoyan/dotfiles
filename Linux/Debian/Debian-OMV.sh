#! /bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

echo -e "\n### Updating the system"
sudo apt-get update -y

echo -e "\n### Install nala"
sudo apt-get install nala -y

# `git`
echo -e '\n### `git`'
sudo apt-get install git -y

# `curl`
echo -e '\n### `curl`'
sudo apt install curl -y

echo -e '\n### create ~/repos/'
mkdir --parents ~/repos
echo -e '\n### cloning dotfiles'
if [ ! -d ~/repos/dotfiles ]; then
    git clone https://github.com/AucaCoyan/dotfiles ~/repos/dotfiles
else
    echo -e '\n ~/repos/doftiles found. Skipping!'
fi

echo -e '\n### symlinking ~/.bashrc'
ln --symbolic --force --no-dereference ~/repos/dotfiles/.config/.bashrc ~/.bashrc


echo -e '\n### `bat`'
sudo apt install bat -y
echo -e '\n### symlinking batcat to bat because of the name collition'
mkdir --parents ~/.local/bin
sudo ln --symbolic --force --no-dereference /usr/bin/batcat /usr/local/bin/bat

echo -e '\n### ripgrep'
sudo apt install ripgrep -y

# Clean up
echo -e '\n### Clean up'
sudo apt autoremove -y