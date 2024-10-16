-- https://github.com/linux-cultist/venv-selector.nvim
return {
  'linux-cultist/venv-selector.nvim',
  branch = 'regexp', -- Use this branch for the new version
  dependencies = {
    'neovim/nvim-lspconfig',
    --'mfussenegger/nvim-dap', 'mfussenegger/nvim-dap-python', --optional
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  cmd = 'VenvSelect',
  opts = {
    settings = {
      options = {
        notify_user_on_venv_activation = true,
        telescope_active_venv_color = '#a6e3a1', -- The color of the active venv in telescope
      },
    },
  },
  --  Call config for python files and load the cached venv automatically
  ft = 'python',
  keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv', ft = 'python' } },
}
