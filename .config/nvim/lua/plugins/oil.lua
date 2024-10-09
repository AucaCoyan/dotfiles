return {
  'stevearc/oil.nvim',
  lazy = true,
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_exporer = false,
    -- Show files and directories that start with "."
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        return vim.startswith(name, '.git') or vim.startswith(name, '..')
      end,
    },
  },

  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },

  keys = {
    { '<leader>o', '<cmd>Oil<cr>', desc = 'Oil' },
  },
}
