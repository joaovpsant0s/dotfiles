-- =============================================================================
-- BRASILIA-NIGHT — AUTOCOMMANDS
-- =============================================================================
local augroup = vim.api.nvim_create_augroup("BrasiliaNightCore", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 180 })
  end,
})

-- 2-space indentation for Lua, Web, YAML, TOML, Markdown
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "lua", "json", "jsonc", "yaml", "toml", "markdown", "html", "css", "typescript", "javascript", "sh" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Trim trailing whitespace on save (except markdown/diff)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "markdown" or ft == "diff" then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
