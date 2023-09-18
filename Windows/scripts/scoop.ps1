$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ps_support.ps1"


# Scoop can utilize aria2 to use multi-connection downloads
scoop install aria2
# disable the warning
scoop config aria2-warning-enabled false

# buckets
scoop bucket add extras

# core
scoop install 7zip audacity autohotkey azuredatastudio bat
scoop install broot calibre delta difftastic discord draw.io 
scoop install dust fd ffmpeg fzf gcc gh git gitui glab glow googlechrome jpegview-fork
scoop install inkscape insomnia keepassxc mongodb mongodb-compass mongosh neovide neovim
scoop install nomino nu obsidian oh-my-posh obs-studio peazip postman powertoys psreadline rga 
scoop install ripgrep rustdesk scoop-completion sublime-merge sumatrapdf teamviewer 
scoop install telegram terminal-icons tokei vcpkg vcredist2022 vlc vscode windirstat zoxide

# programming languages
scoop install deno flutter fnm python rustup surrealdb

# local github actions runner
scoop install main/act

# add rust-analyzer for nvim
rustup component add rust-analyzer


# Install bash-language-server
# npm install -g bash-language-server
# pipx install black
