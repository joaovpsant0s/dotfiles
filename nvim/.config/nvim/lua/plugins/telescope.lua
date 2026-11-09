return {
  {
    "folke/snacks.nvim",
    version = "2.31.0",
    lazy = false,
    priority = 900,
    keys = {
      {
        "<leader>e",
        function()
          require("snacks").explorer()
        end,
        desc = "Explorer",
      },
      {
        "<leader><space>",
        function()
          require("snacks").picker.files()
        end,
        desc = "Find Files",
      },
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
    opts = {
      picker = {
        enabled = true,
        layout = function()
          return vim.o.columns < 105 and "vertical" or "default"
        end,
      },
      notifier = { enabled = true },
      explorer = { enabled = true },
      styles = { dashboard = { wo = { statusline = " " } } },
      dashboard = { enabled = true },
    },
  },
}
