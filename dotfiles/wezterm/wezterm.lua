local wezterm = require 'wezterm'

local config = wezterm.config_builder()

---- color scheme
config.color_scheme = 'tokyonight'

---- UI
config.initial_cols = 120
config.initial_rows = 40

config.enable_scroll_bar = true
config.scrollback_lines = 20000

---- fonts
config.font = wezterm.font('Iosevka Term', { weight = 'Light' })
config.font_size = 16

---- keyboard
-- on macOS, allow composing characters with Left Alt
config.send_composed_key_when_left_alt_is_pressed = true

---- mouse
config.hide_mouse_cursor_when_typing = false

-- helper for simpler keybindings which can have different combinations of mods
-- (see below for examples)
config.keys = {}
function def_key(opts)
  local all_mods
  if type(opts.mods) == 'table' then
    all_mods = opts.mods
  else
    all_mods = { opts.mods }
  end
  for _, mods in pairs(all_mods) do
    table.insert(config.keys, {
      key = opts.key,
      mods = mods,
      action = opts.action,
    })
  end
end

-- open new tabs or windows in the home directory
def_key {
  key = 't',
  mods = { 'SUPER', 'CTRL|SHIFT' },
  action = wezterm.action.SpawnCommandInNewTab {
    cwd = wezterm.home_dir,
  },
}
def_key {
  key = 'n',
  mods = { 'SUPER', 'CTRL|SHIFT' },
  action = wezterm.action.SpawnCommandInNewWindow {
    cwd = wezterm.home_dir,
  },
}

-- select pane with Ctrl+Alt+[hjkl]
for key, direction in pairs { h = 'Left', j = 'Down', k = 'Up', l = 'Right' } do
  def_key {
    key = key,
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivatePaneDirection(direction),
  }
end
-- disable Ctrl+Shift+[Left|Down|Up|Right]
for _, key in pairs { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' } do
  def_key {
    key = key,
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  }
end

config.mouse_bindings = {
  -- Change the default click behavior so that it only selects text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- use Super+Click to open links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = wezterm.action.Nop,
  },
}

return config
