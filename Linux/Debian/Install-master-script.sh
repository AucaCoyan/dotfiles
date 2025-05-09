#! /bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

# setup dark theme in Debian
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

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

# Install catppuccin themes in Gnome Terminal
# curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 -
## Set Ctrl Tab to change tabs
# gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab '<Primary>Tab'
# gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab '<Primary><Shift>Tab'


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
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "/home/$(whoami)/.bashrc"
## add the env variables
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo -e '\n### reload .bashrc'
source ~/.bashrc
# brew recommends to install gcc, but I prefer to have it just on nala or apt-get
# brew install gcc


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


echo -e '\n### `fd`'
sudo apt-get install fd-find -y
echo -e '\n### symlinking fd-find to bat because of the name collition'
ln --symbolic --force --no-dereference $(which fdfind) ~/.local/bin/fd

## install oh-my-posh

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

# fnm (node & npm)
echo -e '\n### `bun`'
curl -fsSL https://bun.sh/install | bash

# rye
# Accept all the defaults
curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash

# VS Code
echo -e '\n### VS Code'
wget --output-document=vscode-stable-x64-linux.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt-get install ./vscode-stable-x64-linux.deb

# Install Kitty Shell
# echo -e '\n### `Kitty shell`'
# curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n # do not launch kitty when finished

# echo -e '\n### `Desktop icon`'
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
# ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
# cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
# cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
# sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
# sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
# echo 'kitty.desktop' > ~/.config/xdg-terminals.list

# Symlink kitty
# ln -s ~/repos/dotfiles/.config/kitty ~/.config/kitty

# rust tools
echo -e '\n### cargo-binstall'
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

echo -e '\n### gitmoji-rs'
# add the `openssl` dependencies https://docs.rs/openssl/latest/openssl/
sudo apt-get install pkg-config libssl-dev -y
cargo binstall gitmoji-rs
gitmoji init --default

cargo binstall --locked bacon
cargo binstall cargo-update
cargo binstall tokei
cargo binstall --locked gfold

echo -e '\n### qdirstat'
sudo apt-get install qdirstat -y

echo -e '\n### delta'
gh release download --repo dandavison/delta --pattern 'git-delta_*amd64.deb'
sudo dpkg -i git-delta*.deb

echo -e '\n### Making Applications folder'
mkdir --parents ~/Applications

brew install biome
brew install fzf
brew install glab
brew install jandedobbeleer/oh-my-posh/oh-my-posh
# `nushell`
brew install nushell
brew install ripgrep

# yazi and dependencies
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font

# Clean up
echo -e '\n### Clean up'
sudo apt autoremove -y
