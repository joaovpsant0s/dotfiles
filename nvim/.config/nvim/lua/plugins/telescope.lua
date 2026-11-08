-- Preferência por Snacks Picker (sem duplicar Telescope)
return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    keys = {
      { "<leader>ff", function() require("snacks").picker.files() end, desc = "Buscar arquivos" },
      { "<leader>fg", function() require("snacks").picker.grep() end, desc = "Buscar texto (ripgrep)" },
      { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Listar buffers" },
      { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Arquivos recentes" },
    },
    opts = function()
      local theme = require("config.theme").current
      local header = table.concat({
        "      ╱╲        ╱╲        ╱╲        ╱╲      ",
        "     ╱  ╲      ╱  ╲      ╱  ╲      ╱  ╲     ",
        "    ╱    ╲____╱    ╲____╱    ╲____╱    ╲    ",
        "    ╲    ╱    ╲    ╱    ╲    ╱    ╲    ╱    ",
        "     ╲  ╱      ╲  ╱      ╲  ╱      ╲  ╱     ",
        "      ╲╱        ╲╱        ╲╱        ╲╱      ",
        "   B R A S I L I A  —  N I G H T   v 2 . 0  ",
        "   " .. (theme.persona.display_name or "João Victor") .. " · UnB/FGA · " .. (theme.variant or "night") .. ":" .. (theme.accent_name or "purple"),
      }, "\n")
      return {
        picker = { enabled = true },
        notifier = { enabled = true },
        dashboard = {
          enabled = true,
          preset = {
            header = header,
            keys = {
              { icon = " ", key = "f", desc = "Buscar arquivo", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "r", desc = "Arquivos recentes", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "a", desc = "Monitoria APC (ApcInit)", action = ":ApcInit" },
              { icon = " ", key = "w", desc = "Abrir Workbench (wb)", action = ":!wb code" },
              { icon = " ", key = "q", desc = "Sair", action = ":qa" },
            },
          },
        },
      }
    end,
  },
}
