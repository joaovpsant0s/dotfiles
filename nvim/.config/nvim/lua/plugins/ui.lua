return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local p = require("config.theme").current.colors
			local function mode(color)
				return {
					a = { fg = p.background_alt, bg = color, gui = "bold" },
					b = { fg = color, bg = p.surface_alt },
					c = { fg = p.foreground, bg = p.background_alt },
				}
			end
			return {
				options = {
					theme = {
						normal = mode(p.accent),
						insert = mode(p.success),
						visual = mode(p.accent_blue),
						replace = mode(p.error),
						command = mode(p.warning),
						inactive = mode(p.foreground_subtle),
					},
					globalstatus = true,
					disabled_filetypes = { statusline = { "snacks_dashboard" } },
					component_separators = { left = "·", right = "·" },
					section_separators = "",
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(value)
								return value:sub(1, 3)
							end,
						},
					},
					lualine_b = { { "branch", icon = "↳" } },
					lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " ro" } } },
					lualine_x = { "diagnostics", { "filetype", icons_enabled = false } },
					lualine_y = {},
					lualine_z = { "location" },
				},
			}
		end,
	},
}
