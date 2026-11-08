return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>tt", function() require("snacks").terminal.toggle() end, desc = "Alternar Terminal Flutuante" },
      { "<leader>gg", function() require("snacks").lazygit() end, desc = "Abrir Lazygit" },
    },
  },
}
