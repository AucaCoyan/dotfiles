-- local colorscheme = "synthwave84"  -- doesn't work
local colorscheme = "shades_of_purple"
-- local colorscheme = "darksplus"
-- local colorscheme = "horizon"
-- local colorscheme = "gruvbox"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

