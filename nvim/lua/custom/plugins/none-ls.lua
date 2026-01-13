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

        -- Python formatting
        null_ls.builtins.formatting.black.with({
          extra_args = { "--line-length=88" }
        }),
        null_ls.builtins.formatting.isort.with({
          extra_args = { "--profile", "black" }
        }),

        -- Java formatting
        null_ls.builtins.formatting.google_java_format,

        -- C/C++ formatting (clang-format)
        null_ls.builtins.formatting.clang_format.with({
          extra_args = { "--style=LLVM" },
          filetypes = { "c", "cpp", "cc", "cxx" },
        }),

        -- JavaScript/TypeScript formatting (prettier)
        null_ls.builtins.formatting.prettier.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            "json",
            "jsonc",
            "yaml",
            "markdown",
            "markdown.mdx",
            "graphql",
            "handlebars",
          },
        }),

        -- CMake formatting
        null_ls.builtins.formatting.cmake_format,
      },
    })

    -- Format on save with leader key
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })

    -- Auto-format on save for specific file types
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.py", "*.java", "*.c", "*.cpp", "*.h", "*.hpp", "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.html" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
      group = augroup,
    })
  end,
}
