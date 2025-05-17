-- LSP Plugins
--
-- -- nushell LSP
-- require('lspconfig').nushell.setup {}
return {

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- Meta type definitions for the Lua platform Luvit.
  -- https://github.com/Bilal2453/luvit-meta
  { 'Bilal2453/luvit-meta', lazy = true },
}
