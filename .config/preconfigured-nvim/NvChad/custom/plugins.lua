local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
      }
    }
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    'wakatime/vim-wakatime',
    lazy = false,
  },

  -- {
  -- -- cargo.toml completion
  --   "saecki/crates.nvim",
  --   ft = {"rust", "toml"},
  --   config = function(_, opts)
  --     local crates = require('crates')
  --     crates.setup(opts)
  --     crates.show()
  --   end
  -- },
  -- {
    -- este auto-session me está fallando,
    -- algo de los comandos pre_save_cmds o post_restore_cmds
    -- me hace fallar todo en nvim
    -- "rmagatti/auto-session",
    -- lazy = false,
    --  cmd = { "SessionSave", "SessionRestore" },
    --  config = function()
    --      require("auto-session").setup {
    --        log_level = "info",
    --        auto_session_enable_last_session = false,
    --        auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
    --        auto_session_enabled = true,
    --        auto_save_enabled = true,
    --        auto_restore_enabled = true,
    --        pre_save_cmds = { "tabdo NvimTreeClose" },
    --        -- commands after loading
    --        post_restore_cmds = { "tabdo NvimTreeFocus" },
    --        -- this fails beacuse nvimtree is lazy loaded
    --     }
    --  end,
  -- }

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

}

return plugins
