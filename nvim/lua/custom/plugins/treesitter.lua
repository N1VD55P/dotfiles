
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    priority = 100,
    opts = {
        ensure_installed = {
          "lua", "python", "javascript", "typescript", "vimdoc", "vim",
          "regex", "sql", "dockerfile", "toml", "json",
          "java", "go", "graphql", "yaml",
          "make", "cmake", "markdown", "markdown_inline", "bash",
          "tsx", "css", "html", "c", "cpp",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      },
  },
}
