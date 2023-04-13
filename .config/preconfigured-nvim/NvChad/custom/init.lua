-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.cmd.language('en_US')                      -- forces vim to have en_US interface language
vim.opt.relativenumber = true                  -- set relative numbered lines
