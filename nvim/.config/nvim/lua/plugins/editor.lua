return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon: Adicionar arquivo" },
      { "<leader>hh", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon: Menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: Arquivo 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: Arquivo 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: Arquivo 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: Arquivo 4" },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Mover para split à esquerda" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Mover para split abaixo" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Mover para split acima" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Mover para split à direita" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Alternar comentário" },
      { "gb", mode = { "n", "v" }, desc = "Alternar comentário em bloco" },
    },
    opts = {},
  },
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()
      require("mini.surround").setup()
    end,
  },
}
