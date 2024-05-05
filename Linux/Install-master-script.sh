#! /bin/bash

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
# set `git push` to automatically setup the remote branch (no need to --set-upstream-to=)
git config --global --add --bool push.autoSetupRemote true
echo -e 'Git has been configured!'
# git config --list

# `curl`
echo -e '\n### `curl`'
sudo apt install curl -y

# Install catppuccin themes in Gnome Terminal
curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 -

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

## add brew to path
echo -e '\n### Adding `brew` to PATH'
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/acoyan/.bashrc
## add the env variables
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo -e '\n### reload .bashrc'
source ~/.bashrc
# brew recommends to install gcc, but I prefer to have it just on apt-get
# brew install gcc

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
ln --symbolic --force --no-dereference ~/repos/dotfiles/nushell ~/.config/nushell

echo -e '\n### `bat`'
sudo apt install bat -y
echo -e '\n### symlinking batcat to bat because of the name collition'
mkdir --parents ~/.local/bin
sudo ln --symbolic --force --no-dereference /usr/bin/batcat /usr/local/bin/bat
# install the catppuccin theme
echo -e '\n### cloning catppuccin/bat'
if [ ! -d ~/other-repos/catppuccin ]; then
    git clone https://github.com/catppuccin/bat ~/other-repos/catppuccin/bat
else
    echo -e '\n ~/other-repos/catppuccin/bat found. Skipping!'
fi
# make a themes dir
mkdir -p "$(bat --config-dir)/themes"
# copy the themes
cp ~/other-repos/catppuccin/bat/themes/*.tmTheme "$(bat --config-dir)/themes"
# rebuild the cache
bat cache --build
# bat theme is assigned in my-aliases.nu

echo -e '\n### `ripgrep`'
brew install ripgrep

echo -e '\n### `fd`'
sudo apt-get install fd-find -y
echo -e '\n### symlinking fd-find to bat because of the name collition'
ln --symbolic --force --no-dereference $(which fdfind) ~/.local/bin/fd

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
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env`"
fnm install --latest

# VS Code
echo -e '\n### VS Code'
wget --output-document=vscode-stable-x64-linux.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install ./vscode-stable-x64-linux.deb

# rust tools
echo -e '\n### gitmoji-rs'
# add the `openssl` dependencies https://docs.rs/openssl/latest/openssl/
sudo apt-get install pkg-config libssl-dev -y
cargo install gitmoji-rs
gitmoji init --default

echo -e '\n### bacon'
cargo install --locked bacon

echo -e '\n### cargo-update'
cargo install cargo-update

echo -e '\n### tokei'
cargo install tokei

echo -e '\n### gfold'
cargo install --locked gfold

# Clean up
echo -e '\n### Clean up'
sudo apt autoremove -y
