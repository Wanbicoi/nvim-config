local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    sql = { "sleek" } --sql_formatter
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
