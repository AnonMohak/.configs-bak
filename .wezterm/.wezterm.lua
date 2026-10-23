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
-- config.enable_tab_bar=false

-- uncomment the above line for no tab bar 
-- all bottom lines for tabbar 
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false
config.tab_and_split_indices_are_zero_based = false

--tabbar block ends 

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
    key = 'x',
    mods = 'CTRL|ALT',
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

-- dakken (typing test): bigger font while it runs.
-- dakken sets the user var dakken_active to "1" at start and "0" at exit.

config.tab_max_width = 24

-- OLD (replaced below): -- shell tab text: "momo" for home, "./<folder>" for any other folder
-- OLD (replaced below): local function short_cwd(pane)
-- OLD (replaced below):   local cwd = pane.current_working_dir
-- OLD (replaced below):   if not cwd then return nil end
-- OLD (replaced below):   local path = (cwd.file_path or tostring(cwd)):gsub('\\', '/'):gsub('/+$', '')
-- OLD (replaced below):   local home = wezterm.home_dir:gsub('\\', '/'):gsub('/+$', '')
-- OLD (replaced below):   if path:lower():sub(-#home) == home:lower() then return 'momo' end
-- OLD (replaced below):   local folder = path:match('([^/]+)$')
-- OLD (replaced below):   return folder and ('./' .. folder) or nil
-- OLD (replaced below): end

-- OLD (replaced below): wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
-- OLD (replaced below):   local pane = tab.active_pane
-- OLD (replaced below):   local title = pane.title
-- OLD (replaced below):   local process = (pane.foreground_process_name or ''):lower()
-- OLD (replaced below):   local text

-- OLD (replaced below):   if process:find('claude') or (title:byte(1) or 0) >= 128 then
-- OLD (replaced below):     -- Claude Code puts its logo as the first character of the title
-- OLD (replaced below):     local icon = title:match('^' .. utf8.charpattern) or ''
-- OLD (replaced below):     text = icon .. ' claude'
-- OLD (replaced below):   elseif process:find('nvim') then
-- OLD (replaced below):     text = 'nvim'
-- OLD (replaced below):   elseif process:find('pwsh') or process:find('powershell') or process:find('cmd%.exe') then
-- OLD (replaced below):     -- shell tab: show the folder
-- OLD (replaced below):     text = short_cwd(pane) or 'pwsh'
-- OLD (replaced below):   else
-- OLD (replaced below):     -- keep only the last word of the title, for example "wezterm.lua"
-- OLD (replaced below):     text = title:match('([^%s\\/]+)%s*$') or title
-- OLD (replaced below):   end
-- OLD (replaced below):   return ' ' .. text .. ' '
-- OLD (replaced below): end)

-- tab bar look: no "+" button, no blocks, only the text changes color
config.show_new_tab_button_in_tab_bar = false
local tab_bar_bg = '#1a1b26' -- tokyonight_night background
local tab_active_fg = '#5DF8D8'
local tab_inactive_fg = '#565f89'
config.colors.tab_bar = {
  background = tab_bar_bg,
  active_tab = { bg_color = tab_bar_bg, fg_color = tab_active_fg },
  inactive_tab = { bg_color = tab_bar_bg, fg_color = tab_inactive_fg },
  inactive_tab_hover = { bg_color = tab_bar_bg, fg_color = tab_active_fg },
}

local tab_separator = ' · '

-- shell tab text: "momo" for home, "./<folder>" for any other folder
local function short_cwd(cwd)
  if not cwd then return nil end
  local path = (cwd.file_path or tostring(cwd)):gsub('\\', '/'):gsub('/+$', '')
  local home = wezterm.home_dir:gsub('\\', '/'):gsub('/+$', '')
  if path:lower():sub(-#home) == home:lower() then return 'momo' end
  local folder = path:match('([^/]+)$')
  return folder and ('./' .. folder) or nil
end

-- the text for one tab; used by the tab bar and by the centering code
local function tab_text(title, process, cwd)
  title = title or ''
  process = (process or ''):lower()
  if process:find('claude') or (title:byte(1) or 0) >= 128 then
    -- Claude Code puts its logo as the first character of the title
    local icon = title:match('^' .. utf8.charpattern) or ''
    return icon .. ' claude'
  elseif process:find('nvim') then
    return 'nvim'
  -- OLD (replaced below): elseif process:find('pwsh') or process:find('powershell') or process:find('cmd%.exe') then
  -- oh-my-posh and zoxide run briefly inside pwsh at startup and at each prompt
  elseif process:find('pwsh') or process:find('powershell') or process:find('cmd%.exe')
      or process:find('oh%-my%-posh') or process:find('zoxide') then
    -- shell tab: show the folder
    return short_cwd(cwd) or 'pwsh'
  end
  -- keep only the last word of the title, for example "wezterm.lua"
  -- OLD (replaced below): return title:match('([^%s\\/]+)%s*$') or title
  -- and drop a trailing ".exe", for example "cargo.exe" becomes "cargo"
  local word = title:match('([^%s\\/]+)%s*$') or title
  return (word:gsub('%.[eE][xX][eE]$', ''))
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local text = tab_text(pane.title, pane.foreground_process_name, pane.current_working_dir)
  local fg = (tab.is_active or hover) and tab_active_fg or tab_inactive_fg
  return {
    { Foreground = { Color = tab_inactive_fg } },
    { Text = tab.tab_index > 0 and tab_separator or '' },
    { Foreground = { Color = fg } },
    { Text = text },
  }
end)

-- run update-status every 100 ms (default 1000) so the tabs center faster
config.status_update_interval = 100

-- center the tabs: pad the left side of the tab bar with spaces
wezterm.on('update-status', function(window, pane)
  window:set_right_status('')
  local tabs = window:mux_window():tabs()
  if #tabs < 2 then
    window:set_left_status('')
    return
  end
  local total = 0
  for i, t in ipairs(tabs) do
    local p = t:active_pane()
    local text = tab_text(p:get_title(), p:get_foreground_process_name(), p:get_current_working_dir())
    if i > 1 then text = tab_separator .. text end
    total = total + math.min(wezterm.column_width(text), config.tab_max_width)
  end
  local cols = window:active_tab():get_size().cols
  window:set_left_status(string.rep(' ', math.max(0, math.floor((cols - total) / 2))))
end)

return config
