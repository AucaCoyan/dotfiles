# ln -s ~/repos/dotfiles/.config/preconfigured-nvim/kickstart.nvim ~/.config/nvim
rm ~/.config/nvim/init.lua
rm -r ~/.config/nvim/lua

ln -s ~/repos/dotfiles/.config/preconfigured-nvim/kickstart.nvim/init.lua ~/.config/nvim/init.lua
ln -s ~/repos/dotfiles/.config/preconfigured-nvim/kickstart.nvim/lua ~/.config/nvim/lua
