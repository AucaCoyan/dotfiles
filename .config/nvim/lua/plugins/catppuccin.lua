return {
    "catppuccin/nvim",
    name = "catppuccin", -- clone with the name "catppuccin"
    lazy = false,
    opts = {
	    flavour = "mocha",
	    transparent_background = true -- disables background color
	},
    config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme catppuccin]])
    end,
}
