-- =============================================================================
-- NOCTURNE — CORE KEYMAPS
-- =============================================================================
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar destaque de busca" })

-- Save and quit shortcuts
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Fechar janela" })

-- Better window navigation (fallback when smart-splits is not loaded yet)
map("n", "<C-h>", "<C-w>h", { desc = "Focar janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Focar janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Focar janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Focar janela à direita" })

-- Move selected lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover seleção para baixo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover seleção para cima" })

-- Keep cursor centered during jumps
map("n", "<C-d>", "<C-d>zz", { desc = "Meia página abaixo centralizado" })
map("n", "<C-u>", "<C-u>zz", { desc = "Meia página acima centralizado" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Próximo buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Fechar buffer" })
