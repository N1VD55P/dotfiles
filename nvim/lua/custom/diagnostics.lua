vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "󰌵",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = " ",
    format = function(diagnostic)
      return string.format("   ●  %s", diagnostic.message)
    end,
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
