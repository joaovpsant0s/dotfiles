-- =============================================================================
-- NOCTURNE — ALGORITHMS & C17/PYTHON RUNNER HELPER
-- =============================================================================
local M = {}

function M.setup()
  vim.api.nvim_create_user_command("AlgoInit", function(opts)
    local dir = opts.args ~= "" and opts.args or vim.fn.expand("%:p:h")
    vim.cmd("botright split | terminal wb init-algo " .. vim.fn.shellescape(dir))
  end, { nargs = "?", complete = "dir", desc = "Algo: Inicializar estrutura de exercício (main.c/solution.py/I/O)" })

  vim.api.nvim_create_user_command("AlgoCheck", function()
    vim.cmd("silent! write")
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
  end, { desc = "Algo: Compilar (-O2 -Wall -Wextra -std=c17) / testar arquivo atual" })

  vim.keymap.set("n", "<leader>ai", "<cmd>AlgoInit<CR>", { desc = "Algo: Inicializar exercício no diretório" })
  vim.keymap.set("n", "<leader>ar", "<cmd>AlgoCheck<CR>", { desc = "Algo: Executar bateria I/O no arquivo atual" })
end

return M
