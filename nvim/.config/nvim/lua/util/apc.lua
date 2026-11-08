-- =============================================================================
-- BRASILIA-NIGHT — MONITORIA APC HELPER (UnB/FGA)
-- Integração direta do Neovim com 'wb init-algo' e 'wb algo-check'
-- =============================================================================
local M = {}

function M.setup()
  vim.api.nvim_create_user_command("ApcInit", function(opts)
    local dir = opts.args ~= "" and opts.args or vim.fn.expand("%:p:h")
    vim.cmd("botright split | terminal wb init-algo " .. vim.fn.shellescape(dir))
  end, { nargs = "?", complete = "dir", desc = "APC: Inicializar estrutura de exercício (main.c/solution.py/I/O)" })

  vim.api.nvim_create_user_command("ApcCheck", function()
    vim.cmd(" silent! write")
    local file = vim.fn.expand("%:p")
    local dir = vim.fn.expand("%:p:h")
    local input = dir .. "/input.txt"
    local expected = dir .. "/expected.txt"
    local cmd = string.format(
      "wb algo-check %s %s %s --yes",
      vim.fn.shellescape(file),
      vim.fn.shellescape(input),
      vim.fn.shellescape(expected)
    )
    vim.cmd("botright 14split | terminal " .. cmd)
  end, { desc = "APC: Compilar (-O2 -Wall -Wextra -std=c17) / testar arquivo atual contra input.txt e expected.txt" })

  vim.keymap.set("n", "<leader>ai", "<cmd>ApcInit<CR>", { desc = "APC: Inicializar exercício no diretório" })
  vim.keymap.set("n", "<leader>ar", "<cmd>ApcCheck<CR>", { desc = "APC: Executar bateria I/O no arquivo atual" })
end

return M
