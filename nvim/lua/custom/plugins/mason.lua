return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 100,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "clangd",
          "ts_ls",
          "html",
          "cssls",
          "emmet_ls",
          "tailwindcss",
          "lua_ls",
          "jsonls",
          "jdtls",
          "eslint",
          "cmake",
        },
        automatic_installation = true,
      })
    end,
  },
}
