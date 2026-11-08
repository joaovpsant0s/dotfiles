return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local theme = require("config.theme").current
      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            function()
              return "🏛 " .. (theme.variant or "night") .. ":" .. (theme.accent_name or "purple")
            end,
            "encoding",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
}
