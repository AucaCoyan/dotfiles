-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { desc = 'general save file' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- source the entire file
-- vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
-- collides with find on opened buffers

-- run the current line
-- [[ Lua]]
vim.keymap.set('n', '<space>lx', ':.lua<CR>', { desc = '[l]ua: Excecute Lua [line]'})
-- collides with delete buffer

-- run the selected lines
vim.keymap.set('v', '<space>lx', ':lua<CR>', { desc = 'E[x]cecute the current visual line' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- resize the windows
-- normal mode
vim.keymap.set('n', '<C-Up>', ':resize +4<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -4<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize +4<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize -4<CR>')

-- terminal mode
vim.keymap.set('t', '<C-Up>', '<cmd>resize +2<CR>')
vim.keymap.set('t', '<C-Down>', '<cmd>resize -2<CR>')
vim.keymap.set('t', '<C-Left>', '<cmd>vertical resize +2<CR>')
vim.keymap.set('t', '<C-Right>', '<cmd>vertical resize -2<CR>')

-- [[ tabs]]
-- go to next tab
vim.keymap.set('n', '<Tab>', '<cmd>tabNext<CR>')
-- shift tab
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>')
-- new tab
vim.keymap.set('n', '<leader>b', '<cmd>enew <CR>', { desc = 'new [b]uffer' })

-- go to the 1st tab
-- it doesn't work
-- vim.keymap.set('n', '<C-\1>', '<cmd>tabfirst <CR>', { desc = 'Go to the first tab' })

-- buffer delete
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', { desc = '[b]uffer [d]elete' })

-- quickfix list
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')

-- save with Ctrl + S
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd> w <cr>')

--- editing
-- in visual mode, press `J` to move the lines down and `K` to move them up
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- relative numbers
-- vim.keymap.set("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
-- vim.keymap.set("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

vim.keymap.set('n', '<leader>wk', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })

-- set wrap in windows/linux and in macos
vim.keymap.set({ 'n', 'i', 'v' }, '<A-z>', '<cmd>set wrap! <CR>', { desc = 'Toggle word wrap' })

-- [[ Python ]]
vim.keymap.set('n', '<leader>pi', '<cmd>!uv pip install --requirements requirements.txt <CR>', { desc = '[p]ython: uv [p]ip [i]nstall requirements' })
vim.keymap.set('n', '<leader>pi', '<cmd>!uv pip install --requirements requirements.txt <CR>', { desc = '[p]ython: uv [p]ip [i]nstall requirements' })
vim.keymap.set('n', '<leader>ps', '<cmd>!uv sync <CR>', { desc = '[p]ython: uv [s]ync' })
vim.keymap.set('n', '<leader>pm', '<cmd>!isort . --force-single-line-imports<CR>', { desc = '[p]ython: isort i[m]ports' })
vim.keymap.set({ 'n', 'i', 'v' }, '<M-z>', '<cmd>set wrap! <CR>', { desc = 'Toggle word wrap' })

-- [[ Rust ]]
vim.keymap.set('n', '<leader>rx', '<cmd>!cargo run<CR>', { desc = '[r]ust: cargo [r]un' })

