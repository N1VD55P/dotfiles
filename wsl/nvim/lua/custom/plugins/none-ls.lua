return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Lua formatting
        null_ls.builtins.formatting.stylua,

        -- Python formatting (no Ruff)
        null_ls.builtins.formatting.black.with({
          extra_args = { "--line-length=88" }
        }),
        null_ls.builtins.formatting.isort.with({
          extra_args = { "--profile", "black" }
        }),

        -- Java formatting
        null_ls.builtins.formatting.google_java_format,

        -- Optional: Python linting with flake8 instead of ruff
        -- null_ls.builtins.diagnostics.flake8.with({
        --     extra_args = { "--max-line-length=88" }
        -- }),
      },
    })

    -- Format on save with leader key
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

    -- Optional: Auto-format Python and Java files on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.py", "*.java" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
      group = augroup,
    })
  end,
}
