-- WezTerm Configuration
-- File: %USERPROFILE%\.wezterm.lua (Windows)

local wezterm = require 'wezterm'
local config = {}

-- Use config builder if available
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- DEFAULT SHELL (Windows/WSL)

config.default_prog = { "wsl.exe", "-d", "Ubuntu", "--", "zsh", "-c", "cd ~ && exec zsh" }

-- Launch Menu - Multiple shell options
config.launch_menu = {
  {
    label = 'WSL Ubuntu (Zsh)',
    args = { 'wsl.exe', '-d', 'Ubuntu', '--', 'zsh', '-c', 'cd ~ && exec zsh' },
  },
  {
    label = 'WSL Ubuntu (Bash)',
    args = { 'wsl.exe', '-d', 'Ubuntu', '--', 'bash', '-c', 'cd ~ && exec bash' },
  },
  {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  },
  {
    label = 'PowerShell Core',
    args = { 'pwsh.exe', '-NoLogo' },
  },
  {
    label = 'Command Prompt',
    args = { 'cmd.exe' },
  },
}
-- KEY MAPPINGS
config.keys = {
  -- Tab navigation
  { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  
  -- Create new tab
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  
  -- Close current tab
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab{ confirm = true } },
  
  -- Show launch menu
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
  
  -- Switch to specific tabs
  { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = wezterm.action.ActivateTab(8) },
}
config.font = wezterm.font_with_fallback({
  { family = "IBM Plex Mono", weight = "Regular" },
  { family = "JetBrainsMono Nerd Font", weight = "Medium" },
})

config.font_size = 15.0
-- Tab bar settings
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true

-- Window padding
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- PERFORMANCE & BEHAVIOR
config.colors = {
  cursor_bg = "#FFFFFF",
  cursor_fg = "#000000",
  cursor_border = "#FFFFFF",
}
config.default_cursor_style = "BlinkingBlock"
config.enable_scroll_bar = false
config.scrollback_lines = 10000
config.audible_bell = 'Disabled'

-- Window settings
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'NeverPrompt'

-- Launch maximized
config.initial_rows = 999
config.initial_cols = 999

return config
