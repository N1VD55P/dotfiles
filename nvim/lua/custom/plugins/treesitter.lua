
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").prefer_git = false
      vim.cmd(":TSUpdate")
    end,
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSUninstall" },
    opts = {
      ensure_installed = {
        "lua", "python", "javascript", "typescript", "vimdoc", "vim",
        "regex", "sql", "dockerfile", "toml", "json",
        "java", "go", "graphql", "yaml",
        "make", "cmake", "markdown", "markdown_inline", "bash",
        "tsx", "css", "html", "c", "cpp",
      },
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
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
