return {
  {
    'folke/tokyonight.nvim',
    enabled = false,
  },
  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    enabled = false,
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      flavour = 'mocha',
      transparent_background = true,
    },
  },
  {
    'eldritch-theme/eldritch.nvim',
    enabled = false,
    lazy = false,
  },
  {
    'Mofiqul/vscode.nvim',
    enabled = false,
    opts = {
      transparent_background = true,
    },
  },
  {
    'ellisonleao/gruvbox.nvim',
    enabled = true,
    priority = 1000,
    opts = { transparent_background = true },

    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'gruvbox'

      -- You can configure highlights by doing something like:
      --vim.cmd.hi 'Comment gui=none'
    end,
  },
}
