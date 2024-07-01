local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'tokyonight'

config.font = wezterm.font('Iosevka Term', { weight = 'Light' })
config.font_size = 16

return config
