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
        "               /\\               ",
        "              /  \\              ",
        "             / /\\ \\             ",
        "            / /  \\ \\            ",
        "           / /____\\ \\           ",
        "          /_/      \\_\\          ",
        "   N O C T U R N E  ·  A R C H  ",
        "   " .. (theme.variant or "night") .. ":" .. (theme.accent_name or "purple") .. " · i use arch, btw",
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
              { icon = " ", key = "a", desc = "Algorithms Runner (AlgoInit)", action = ":AlgoInit" },
              { icon = " ", key = "w", desc = "Abrir Workbench (wb)", action = ":!wb code" },
              { icon = " ", key = "q", desc = "Sair", action = ":qa" },
            },
          },
        },
      }
    end,
  },
}
