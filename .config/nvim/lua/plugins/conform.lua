return { -- Autoformat
  'stevearc/conform.nvim',
  log_level = vim.log.levels.DEBUG,
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>ft',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      python = { 'ruff_format', 'isort' },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'biome', 'prettier', stop_after_first = true },
      typescript = { 'biome', 'prettier', stop_after_first = true },
      json = { 'biome' },
    },
    -- formatters = {
    --   isort = {
    --     inherit = false,
    --     command = 'isort',
    --     args = { '$FILENAME', '--force-single-line-imports', '--stdout' },
    --   },
    -- },
  },
}
