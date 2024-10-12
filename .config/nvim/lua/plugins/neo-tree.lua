-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = false,
  branch = 'v3.x',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal right<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          -- change type
          added = 'A',
          deleted = 'D',
          modified = 'M',
          -- status type
          untracked = 'U',
          -- ignored, stated, unstaged & conflict
        },
      },
    },
    filesystem = {
      window = {
        position = 'right',
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          'node_modules',
          '.git',
        },
      },
    },
    follow_current_file = {
      enabled = true,
    },
    hijack_netrw_behavior = 'open_default',
  },
}
