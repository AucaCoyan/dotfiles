return {
  'stevearc/oil.nvim',
  opts = {},
  default_file_exporer = false,
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = true,
  -- Show files and directories that start with "."
  show_hidden = false,
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
