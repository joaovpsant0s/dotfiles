return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        sql = { "sqlfluff" },
        markdown = { "markdownlint-cli2" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}
