-- =============================================================================
-- BRASILIA-NIGHT — DIAGNOSTICS CONFIGURATION
-- =============================================================================
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "▪",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "◆",
      [vim.diagnostic.severity.INFO] = "ℹ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})
