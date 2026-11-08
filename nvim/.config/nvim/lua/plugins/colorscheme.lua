return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      local theme = require("config.theme").current
      return {
        style = theme.tokyonight_style or "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false },
          sidebars = "dark",
          floats = "dark",
        },
        on_highlights = function(hl, c)
          local accent = (theme.colors and theme.colors.accent) or c.purple
          hl.FloatBorder = { fg = accent, bg = c.bg_dark }
          hl.WinSeparator = { fg = (theme.colors and theme.colors.border) or c.border_highlight }
          hl.CursorLineNr = { fg = accent, bold = true }
        end,
      }
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
