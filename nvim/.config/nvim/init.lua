-- =============================================================================
-- NOCTURNE — NEOVIM >= 0.11 ENTRYPOINT
-- Arquitetura: Modular Lua + Native vim.lsp.config + Lazy.nvim (strict lazy)
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Enable faster Lua module bytecode loader (Neovim >= 0.9+)
if vim.loader then
  vim.loader.enable()
end

require("config.options")
require("config.theme")
require("config.diagnostics")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")
require("util.apc").setup()

-- Bootstrap lazy.nvim safely (only when network/git is available or already installed)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  if vim.fn.executable("git") == 1 and vim.env.BN_NVIM_OFFLINE ~= "1" then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
end

if (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)
  local ok, lazy = pcall(require, "lazy")
  if ok then
    lazy.setup({
      spec = {
        { import = "plugins" },
      },
      defaults = {
        lazy = true,
        version = false,
      },
      install = {
        colorscheme = { "tokyonight", "habamax" },
      },
      checker = {
        enabled = false,
      },
      change_detection = {
        notify = false,
      },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            "matchit",
            "matchparen",
            "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    })
  end
end
