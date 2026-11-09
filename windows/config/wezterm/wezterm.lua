-- =============================================================================
-- NOCTURNE — WEZTERM CONFIGURATION (Windows 11 Host -> Arch WSL 2)
-- =============================================================================
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Default into Arch Linux WSL 2
config.default_domain = "WSL:archlinux"

-- Typography: GeistMono Nerd Font with immediate fallback to installed Geist Mono & JetBrains Mono
config.font = wezterm.font_with_fallback({
  { family = "GeistMono Nerd Font", weight = "Regular" },
  { family = "Geist Mono", weight = "Regular" },
  { family = "JetBrainsMono Nerd Font", weight = "Regular" },
  { family = "JetBrains Mono", weight = "Regular" },
  { family = "Symbols Nerd Font Mono", weight = "Regular" },
})
config.font_size = 11.5
config.line_height = 1.12
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- Theme: generated nocturne TOML in ./colors/nocturne.toml (fallback: Tokyo Night)
local config_dir = wezterm.config_dir or ""
local theme_file = config_dir .. "/colors/nocturne.toml"
local f = io.open(theme_file, "r")
if f then
  f:close()
  config.color_scheme_dirs = { config_dir .. "/colors" }
  config.color_scheme = "nocturne"
else
  config.color_scheme = "Tokyo Night"
end

-- Window & Architectural Geometry
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 14,
  right = 14,
  top = 12,
  bottom = 10,
}
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.tab_max_width = 36

-- Optional Acrylic / Backdrop (controlled via WEZTERM_BACKDROP=1)
if os.getenv("WEZTERM_BACKDROP") == "1" then
  config.window_background_opacity = 0.94
  config.win32_system_backdrop = "Acrylic"
else
  config.window_background_opacity = 1.0
end

-- Performance & Cursor (zero unnecessary animations)
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120
config.animation_fps = 1
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0
config.audible_bell = "Disabled"
config.automatically_reload_config = true
config.scrollback_lines = 20000

-- Keybindings
config.keys = {
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "|", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "_", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
  { key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
}

return config
