-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- run nushell
	config.default_prog = { "C:\\Users\\aucac\\scoop\\shims\\nu.exe" }
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	-- run nushell
	config.default_prog = {}
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Frappe"

-- and finally, return the configuration to wezterm
return config
