local wezterm = require 'wezterm'

local config = wezterm.config_builder()

---- persistence
config.unix_domains = {
  { name = 'unix' },
}
config.default_gui_startup_args = { 'connect', 'unix' }

---- color scheme
config.color_scheme = 'tokyonight'

---- UI
config.enable_scroll_bar = true
config.scrollback_lines = 20000

---- fonts
config.font = wezterm.font('Iosevka Term', { weight = 'Light' })
config.font_size = 16

---- keyboard
-- on macOS, allow composing characters with Left Alt
config.send_composed_key_when_left_alt_is_pressed = true

return config
