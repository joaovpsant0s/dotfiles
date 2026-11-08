return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason (apenas ferramentas ausentes no Pacman)" },
    },
    opts = {
      ui = { border = "rounded" },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnósticos (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnósticos do Buffer" },
    },
    opts = {},
  },
}
