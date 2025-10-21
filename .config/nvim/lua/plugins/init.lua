-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
return {
  -- TODO: does it work?
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- TODO: see if we need these
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.lint',
}
