-- =============================================================================
-- BRASILIA-NIGHT — NATIVE NEOVIM 0.11+ LSP CONFIGURATION
-- Utiliza vim.lsp.config() e vim.lsp.enable() com verificação vim.fn.executable
-- =============================================================================
local servers = {
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { "compile_commands.json", ".clangd", "Makefile", ".git" },
  },
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "standard",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".git" },
  },
  vtsls = {
    cmd = { "vtsls", "--stdio" },
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_markers = { "tsconfig.json", "package.json", ".git" },
  },
  jdtls = {
    cmd = { "jdtls" },
    filetypes = { "java" },
    root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", ".git" },
  },
  sqlls = {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    filetypes = { "sql", "mysql" },
    root_markers = { ".git" },
  },
  texlab = {
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    root_markers = { ".latexmkrc", ".git" },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".git" },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash", "zsh" },
    root_markers = { ".git" },
  },
  marksman = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_markers = { ".marksman.toml", ".git" },
  },
}

-- Fallback para pyright caso basedpyright não esteja instalado
if vim.fn.executable("basedpyright-langserver") == 0 and vim.fn.executable("pyright-langserver") == 1 then
  servers.pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "requirements.txt", ".git" },
  }
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("BrasiliaNightLspAttach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    map("gd", vim.lsp.buf.definition, "Ir para definição")
    map("gD", vim.lsp.buf.declaration, "Ir para declaração")
    map("gr", vim.lsp.buf.references, "Listar referências")
    map("gi", vim.lsp.buf.implementation, "Ir para implementação")
    map("K", vim.lsp.buf.hover, "Documentação Hover")
    map("<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
    map("<leader>ca", vim.lsp.buf.code_action, "Ações de código")
  end,
})

-- Native Neovim 0.11+ registration
if vim.lsp and type(vim.lsp.config) == "function" and type(vim.lsp.enable) == "function" then
  local enabled_servers = {}
  for name, cfg in pairs(servers) do
    local bin = cfg.cmd and cfg.cmd[1]
    if bin and vim.fn.executable(bin) == 1 then
      vim.lsp.config(name, cfg)
      table.insert(enabled_servers, name)
    end
  end
  if #enabled_servers > 0 then
    vim.lsp.enable(enabled_servers)
  end
end
