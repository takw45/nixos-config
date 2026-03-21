local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 背景透過
config.window_background_opacity = 0.85

config.enable_wayland = true
config.audible_bell = "Disabled"
config.check_for_updates = false

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 45,
}

config.font = wezterm.font("Hackgen Console NF")
config.font_size = 14.0
config.line_height = 1.05

config.cursor_thickness = "2pt"
config.scrollback_lines = 20000
config.adjust_window_size_when_changing_font_size = false
config.animation_fps = 60

-- OSで設定を分ける
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { 'pwsh.exe' }
else
    config.default_prog = { "zsh", "-l" }
end
config.color_scheme = 'Catppuccin Mocha (Gogh)'


config.leader = {
  key = "a",
  mods = "CTRL",
  timeout_milliseconds = 1000,
}

config.keys = {
  {
    key = "Enter",
    mods = "ALT",
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = "t",
    mods = "LEADER",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },
  {
    key = "+",
    mods = "CTRL",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action.ResetFontSize,
  },
  {
    key = "1",
    mods = "LEADER",
    action = wezterm.action.SendString("zellij --layout terminal-ide\n"),
  },
  {
    key = "2",
    mods = "LEADER",
    action = wezterm.action.SendString("zellij\n"),
  },
}

return config
