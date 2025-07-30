return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
    "astro",
    "css",
    "html",
    "git_config",
    "gitignore",
    "javascript",
    "json",
    "jsonc",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "rust",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
"vimdoc",
    "yaml",
  		},
  	},
  },
  {
    'wakatime/vim-wakatime',
    lazy = false,
  },
  {
  -- cargo.toml completion
    "saecki/crates.nvim",
    ft = {"rust", "toml"},
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      crates.show()
    end
  },
}
