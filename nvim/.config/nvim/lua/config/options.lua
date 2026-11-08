-- =============================================================================
-- BRASILIA-NIGHT — NEOVIM CORE OPTIONS
-- =============================================================================
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.colorcolumn = "100"
opt.termguicolors = true
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 1

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"

opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 200
opt.timeoutlen = 300
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.fillchars = { eob = " ", vert = "│", fold = "─" }
