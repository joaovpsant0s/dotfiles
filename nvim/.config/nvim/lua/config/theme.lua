local M = {}

local default_theme = {
  variant = "night",
  accent_name = "purple",
  tokyonight_style = "night",
  persona = {
    owner_name = "João Victor Pereira Santos",
    display_name = "João Victor",
    username = "JVZerinho",
    github_username = "joaovpsant0s",
    hostname = "arch",
    signature = "arch",
    tagline = "i use arch, btw",
    professional_role = "Software & Data Engineer",
  },
  colors = {
    background = "#1a1b26",
    background_alt = "#16161e",
    surface = "#24283b",
    surface_alt = "#292e42",
    foreground = "#c0caf5",
    foreground_muted = "#a9b1d6",
    foreground_subtle = "#565f89",
    accent = "#bb9af7",
    accent_blue = "#7aa2f7",
    accent_purple = "#bb9af7",
    accent_secondary = "#7aa2f7",
    border = "#3b4261",
    selection = "#283457",
    cursor = "#c0caf5",
    success = "#9ece6a",
    warning = "#e0af68",
    error = "#f7768e",
    info = "#7dcfff",
  },
}

local ok, generated = pcall(require, "config.theme_generated")
if ok and type(generated) == "table" then
  M.current = generated
else
  M.current = default_theme
end

vim.g.nocturne_theme = M.current
return M
