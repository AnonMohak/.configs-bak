-- crtl+shift = cmd
-- ALT+ENTER = toggle fullscreen
-- cmd+t = new tab
-- cmd+w = kill that tab
-- cmd+d = split terminal horz
-- cmd+s = split terminal ver
-- cmd+c = clear terminal
-- cmd+h = focus pane left 
-- cmd+l = focus pane right
-- cmd+k = focus pane up
-- cmd+j = focus pane down

local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

--test
-- config.window_background_opacity = 0.0
-- config.text_background_opacity = 0.0

--clear bg

-- config.win32_system_backdrop = "Acrylic"
-- config.window_background_opacity = 0.8

-- General

config.default_prog = {'pwsh.exe', '-NoLogo'}
config.font_size = 15
-- config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.color_scheme = "tokyonight_night"

config.colors = {
  cursor_bg = "#5DF8D8",
  cursor_border = "#5DF8D8"
}

config.window_decorations='RESIZE'
config.enable_tab_bar=false

-- Key bindings

config.keys = {
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane {confirm=false},
  },
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal {domain = 'CurrentPaneDomain'},
  },
  {
    key = 's',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical {domain = 'CurrentPaneDomain'},
  },
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SendString("cls\r"),
  },
  { key = 'h',
  mods = 'CTRL|SHIFT', 
  action = wezterm.action.ActivatePaneDirection 'Left'
  },
  { 
    key = 'l', 
    mods = 'CTRL|SHIFT', 
    action = wezterm.action.ActivatePaneDirection 'Right' 
  },
  { 
    key = 'k', 
    mods = 'CTRL|SHIFT', 
    action = wezterm.action.ActivatePaneDirection 'Up' 
  },
  { 
    key = 'j', 
    mods = 'CTRL|SHIFT', 
    action = wezterm.action.ActivatePaneDirection 'Down' 
  },
}

--on-startup events

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

return config
