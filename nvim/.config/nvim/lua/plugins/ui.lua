return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
        component_separators = { left = "·", right = "·" },
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "diagnostics", { "filename", path = 1 } },
        lualine_x = { "diff", { "filetype", icons_enabled = false } },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
