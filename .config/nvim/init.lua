-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

require 'config.options'
-- structured installation
-- https://lazy.folke.io/installation
require 'config.lazy'

if vim.g.neovide then
  vim.print(vim.g.neovide_version)
  --vim.o.guifont = 'Hack,Noto_Color_Emoji,FiraCode Nerd Font:h12'
  vim.o.guifont = 'FiraCode Nerd Font:h12'
end

vim.lsp.enable({'rust-analyzer', 'lua-language-server', 'clangd'})
