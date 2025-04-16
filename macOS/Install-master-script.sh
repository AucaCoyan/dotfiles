#! /bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

echo -e "###### macOS installation script ######"

# Brew
echo -e '\n### `brew`'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ==> Formulae
brew install git
brew install gh
brew install neovim
brew install nushell
# brew install glab
brew install fzf
brew install ripgrep
brew install lazygit
brew install mdbook

brew install fnm
fnm install --latest

echo -e '\n### `oh-my-posh`'
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# ==> Casks
# install `FiraCode`
brew install --cask font-fira-code-nerd-font
brew install --cask brave-browser
brew install --cask discord
brew install --cask ghostty
brew install --cask librewolf
brew install --cask obsidian
brew install --cask vlc

# Git Configuration
echo -e '\n### Configure git'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
# set `git push` to automatically setup the remote branch (no need to --set-upstream-to=)
git config --global --bool push.autoSetupRemote true
git config --global pull.rebase true
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

echo -e '\n### making a symlink to ~/repos/dotfiles/.config/ghostty'
# mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
ln -s -F ~/repos/dotfiles/.config/ghostty ~/Library/Application\ Support/com.mitchellh.ghostty

echo -e '\n### making a symlink to ~/repos/dotfiles/.config/lazygit/'
ln -s -F ~/repos/dotfiles/.config/lazygit ~/Library/Application\ Support

echo -e '\n### Rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# rust tools
echo -e '\n### cargo-binstall'
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

cargo binstall gitmoji-rs
gitmoji init --default

echo -e '\n### cargo binstall bat'
cargo binstall bat

echo -e '\n### cargo binstall fd-find'
cargo binstall fd-find

echo -e '\n### cargo-update'
cargo binstall cargo-update
