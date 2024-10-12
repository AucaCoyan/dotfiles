return {
  {
    'folke/tokyonight.nvim',
  },
  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      flavour = 'mocha',
      transparent_background = true,
    },
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'catppuccin'

      -- You can configure highlights by doing something like:
      --vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'eldritch-theme/eldritch.nvim',
    -- lazy = 'VeryLazy',
  },
  {
    'Mofiqul/vscode.nvim',
    opts = {
      transparent_background = true,
    },
  },
  { 'ellisonleao/gruvbox.nvim', priority = 1000, opts = { transparent_background = true } },
}
