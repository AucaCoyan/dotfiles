#! /bin/zsh

set -eu -o pipefail # fail on error and report it, debug all lines

echo -e "###### macOS installation script ######"

# Brew
echo -e '\n### `brew`'
# || is an OR operator. Sends the command only if the first part gave an error
# forward to /dev/null to bypass the "Press enter to continue" step
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git
brew install gh
brew install neovim
brew install nushell
# brew install glab
brew install fzf
brew install ripgrep

echo -e '\n### `oh-my-posh`'
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Git Configuration
echo -e '\n### Configure git'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
# set `git push` to automatically setup the remote branch (no need to --set-upstream-to=)
git config --global --add --bool push.autoSetupRemote true
echo -e 'Git has been configured!'


# repos and other-repos folders
echo -e '\n### create ~/repos/'
mkdir -p ~/repos
echo -e '\n### cloning dotfiles'
if [ ! -d ~/repos/dotfiles ]; then
    git clone https://github.com/AucaCoyan/dotfiles ~/repos/dotfiles
else
    echo -e '\n ~/repos/doftiles found. Skipping!'
fi

echo -e '\n### create ~/other-repos/'
mkdir -p ~/other-repos
echo -e '\n### cloning nu_scripts'
if [ ! -d ~/other-repos/nu/nu_scripts ]; then
    git clone https://github.com/nushell/nu_scripts ~/other-repos/nu/nu_scripts
else
    echo -e '\n ~/other-repos/nu/nu_scripts found. Skipping!'
fi

echo -e '\n### making a symlink to ~/repos/dotfiles/nushell'
ln -s -F ~/repos/dotfiles/nushell ~/Library/Application\ Support/

echo -e '\n### making a symlink to ~/repos/dotfiles/.config/nvim'
ln -s -F ~/repos/dotfiles/.config/nvim ~/.config/nvim

echo -e '\n### Rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# rust tools
echo -e '\n### cargo-binstall'
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

cargo binstall gitmoji-rs
gitmoji init --default

cargo binstall bat
cargo binstall fd-find

## add brew to path
# echo -e '\n### Adding `brew` to PATH'
# (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "/home/$(whoami)/.bashrc"
# ## add the env variables
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# echo -e '\n### reload .bashrc'
# source ~/.bashrc

# echo -e '\n### `fd`'
# sudo apt-get install fd-find -y
# echo -e '\n### symlinking fd-find to bat because of the name collition'
# ln --symbolic --force --no-dereference $(which fdfind) ~/.local/bin/fd
#
#
# # install `FiraCode`
# echo -e '\nInstalling Font FiraCode'
# mkdir --parents ~/.local/share/fonts
# cd ~/.local/share/fonts
# curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz
# # unzip
# tar xf FiraCode.tar.xz
