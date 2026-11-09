return {
	{
		"nvim-treesitter/nvim-treesitter",
		cond = vim.fn.has("nvim-0.12") == 0,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"java",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"sql",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
