return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Formatar buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "ruff_organize_imports", "ruff_format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        sql = { "sqlfluff" },
        typescript = { "biome", "prettier", stop_after_first = true },
        javascript = { "biome", "prettier", stop_after_first = true },
        markdown = { "markdownlint-cli2" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
