-- [[ [[ Setting and options of vim/neovim]] ]]
-- For more options, you can see `:help option-list`
-- See `:help vim.opt`
--
--  If you want to test an option with lua, type:
--  `:lua vim.opt.<option> = 'value'` and see if it works.
--
-- as Sept 15th, 2024, it's recommended to use `vim.o` instead of `vim.opt`
-- because the latter will be eventually deprecated
-- source: https://github.com/neovim/neovim/issues/30383#issuecomment-2351519326

-- [[ tab options ]]
-- number of spaces that <Tab> in file uses
vim.o.tabstop = 4
-- number of spaces to use for (auto)indent step (the number of spaces inserted for each indentation)
vim.o.shiftwidth = 4
-- tells when the tab pages line is displayed
-- always show tabs
vim.opt.showtabline = 2
-- use spaces when <Tab> is inserted
vim.opt.expandtab = true

-- Make line numbers default
vim.opt.number = true
-- Set relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- disable highlighting the cursorline
vim.opt.cursorline = false

-- Line lenght marker at 80 columns
vim.opt.colorcolumn = '80'

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- set the background dark (for themes that have light and dark background)
vim.o.background = 'dark'

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Clear highlights on search when pressing <Esc> in normal mode
vim.opt.hlsearch = true
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- creates a backup file
vim.opt.backup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.writebackup = false
-- more space in the neovim command line for displaying messages
-- mostly just for cmp
vim.opt.cmdheight = 2
vim.opt.completeopt = { 'menuone', 'noselect' }
-- so that `` is visible in markdown files
vim.opt.conceallevel = 0
-- the encoding written to a file
vim.opt.fileencoding = 'utf-8'
-- make indenting smarter again
vim.opt.smartindent = true
-- creates a swapfile
vim.opt.swapfile = false
-- set term gui colors (most terminals support this)
vim.opt.termguicolors = true
-- display lines as one long line
vim.opt.wrap = false

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true