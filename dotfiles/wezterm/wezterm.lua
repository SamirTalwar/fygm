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

-- helper for simpler keybindings which can have different combinations of mods
-- (see below for examples)
config.keys = {}
function key(opts)
  local all_mods
  if type(opts.mods) == 'table' then
    all_mods = opts.mods
  else
    all_mods = { opts.mods }
  end
  for _, mods in pairs(all_mods) do
    local key = opts.key
    for match in string.gmatch(opts.key, '%a+') do
      if match == 'SHIFT' then
        key = string.upper(key)
      end
    end
    table.insert(config.keys, {
      key = opts.key,
      mods = mods,
      action = opts.action,
    })
  end
end

-- open new tabs or windows in the home directory
key {
  key = 't',
  mods = { 'SUPER', 'CTRL|SHIFT' },
  action = wezterm.action.SpawnCommandInNewTab {
    cwd = wezterm.home_dir,
  },
}
key {
  key = 'n',
  mods = { 'SUPER', 'CTRL|SHIFT' },
  action = wezterm.action.SpawnCommandInNewWindow {
    cwd = wezterm.home_dir,
  },
}

return config
