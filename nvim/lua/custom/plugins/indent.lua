return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2a2a3a" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#4a5568" })

    require("ibl").setup({
      indent = {
        char = "▏",
        highlight = "IblIndent",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        highlight = "IblScope",
      },
    })
  end,
}
