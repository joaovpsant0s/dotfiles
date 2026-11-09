local function pick_projects()
	local cwd = Snacks.git.get_root(vim.fn.getcwd()) or vim.fn.getcwd()
	local items = { { text = cwd, file = cwd, dir = cwd } }
	local seen = { [cwd] = true }
	for _, root in ipairs({ vim.fn.expand("~/dev"), vim.fn.expand("~/projects") }) do
		if vim.fn.isdirectory(root) == 1 then
			for name, kind in vim.fs.dir(root) do
				local path = vim.fs.joinpath(root, name)
				if kind == "directory" and name:sub(1, 1) ~= "." and not seen[path] then
					items[#items + 1] = { text = path, file = path, dir = path }
					seen[path] = true
				end
			end
		end
	end
	Snacks.picker({ title = "Projetos", items = items, format = "file", confirm = "load_session" })
end

return {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 900,
		keys = {
			{
				"<leader>ff",
				function()
					require("snacks").picker.files()
				end,
				desc = "Buscar arquivos",
			},
			{
				"<leader>fg",
				function()
					require("snacks").picker.grep()
				end,
				desc = "Buscar texto (ripgrep)",
			},
			{
				"<leader>fb",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "Listar buffers",
			},
			{
				"<leader>fr",
				function()
					require("snacks").picker.recent()
				end,
				desc = "Arquivos recentes",
			},
		},
		opts = function()
			local theme = require("config.theme").current
			local header = [[
█▄ █  █▀█  █▀▀  ▀█▀  █ █  █▀█  █▄ █  █▀▀
█ ▀█  █▄█  █▄▄   █   █▄█  █▀▄  █ ▀█  ██▄
]]
			return {
				picker = {
					enabled = true,
					layout = function()
						return vim.o.columns < 105 and "vertical" or "default"
					end,
				},
				notifier = { enabled = true, style = "compact" },
				styles = { dashboard = { wo = { statusline = " " } } },
				dashboard = {
					enabled = true,
					width = 48,
					sections = {
						{ header = header, padding = { 0, 1 } },
						{ footer = theme.persona.tagline, padding = { 0, 2 } },
						{ section = "keys", padding = 1 },
						{ section = "startup", padding = 1 },
					},
					preset = {
						keys = {
							{
								icon = " ",
								key = "f",
								desc = "Buscar arquivo",
								action = ":lua Snacks.dashboard.pick('files')",
							},
							{
								icon = " ",
								key = "r",
								desc = "Arquivos recentes",
								action = ":lua Snacks.dashboard.pick('oldfiles')",
							},
							{
								icon = " ",
								key = "p",
								desc = "Projetos",
								action = pick_projects,
							},
							{
								icon = " ",
								key = "g",
								desc = "Git",
								action = function()
									Snacks.lazygit()
								end,
							},
							{ icon = " ", key = "a", desc = "Exercício de algoritmos", action = ":AlgoInit" },
							{ icon = " ", key = "q", desc = "Sair", action = ":qa" },
						},
					},
				},
			}
		end,
	},
}
