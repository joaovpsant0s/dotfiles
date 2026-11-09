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
				cache = false,
				styles = {
					comments = { italic = true },
					keywords = { italic = false },
					sidebars = "dark",
					floats = "dark",
				},
				on_colors = function(c)
					local p = theme.colors
					c.bg, c.bg_dark, c.bg_float = p.background, p.background_alt, p.surface
					c.bg_popup, c.bg_sidebar = p.surface, p.background_alt
					c.bg_highlight, c.bg_visual = p.surface_alt, p.selection
					c.fg, c.fg_dark, c.comment = p.foreground, p.foreground_muted, p.foreground_subtle
					c.border, c.border_highlight = p.border, p.accent
				end,
				on_highlights = function(hl)
					local p = theme.colors
					hl.FloatBorder = { fg = p.border, bg = p.surface }
					hl.FloatTitle = { fg = p.accent, bg = p.surface, bold = true }
					hl.WinSeparator = { fg = p.border }
					hl.CursorLineNr = { fg = p.accent, bold = true }
					hl.SnacksDashboardHeader = { fg = p.accent, bold = true }
					hl.SnacksDashboardIcon = { fg = p.accent_blue }
					hl.SnacksDashboardKey = { fg = p.accent, bold = true }
					hl.SnacksDashboardDesc = { fg = p.foreground }
					hl.SnacksDashboardFooter = { fg = p.foreground_subtle }
					hl.SnacksDashboardTitle = { fg = p.foreground_muted, bold = true }
					hl.SnacksPickerInputBorder = { fg = p.accent, bg = p.surface }
					hl.SnacksPickerInputTitle = { fg = p.accent, bg = p.surface, bold = true }
					hl.SnacksPickerListCursorLine = { bg = p.selection }
					hl.BlinkCmpMenuBorder = { fg = p.border, bg = p.surface }
					hl.BlinkCmpDocBorder = { fg = p.border, bg = p.surface }
				end,
			}
		end,
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
