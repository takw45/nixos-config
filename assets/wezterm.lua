local wezterm = require 'wezterm'
local config = {
    font = wezterm.font("Hackgen Console NF"),
    font_size = 13
}

-- 背景透過
config.window_background_opacity = 0.85

-- OSで設定を分ける
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { 'pwsh.exe' }
else
    config.default_prog = { 'zsh' }
end

config.color_scheme = 'Catppuccin Mocha (Gogh)'
-- config.color_scheme = 'Colorful Colors (terminal.sexy)'

config.cursor_thickness = "2pt"
config.scrollback_lines = 3500
config.animation_fps = 60

return config
