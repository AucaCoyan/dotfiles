return {
  'tamton-aquib/duck.nvim',
  config = function()
    vim.keymap.set('n', '<leader>dd', function()
      require('duck').hatch()
    end, { desc = '[D]uck [d]uck' })
    vim.keymap.set('n', '<leader>dr', function()
      require('duck').cook()
    end, { desc = '[D]uck [r]emove' })
    vim.keymap.set('n', '<leader>da', function()
      require('duck').cook_all()
    end, { desc = '[D]uck remove [a]ll' })
  end,
}
