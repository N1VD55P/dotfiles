return {
        {
                "folke/tokyonight.nvim",
                priority = 1000,
                config = function()
                        require("tokyonight").setup({
                                style = "storm",
                                on_colors = function(colors)
                                        colors.bg = "#0a0e27"
                                        colors.bg_dark = "#050810"
                                        colors.bg_float = "#0f1219"
                                end,
                                on_highlights = function(hl, c)
                                        hl.Function = { fg = c.blue, bold = true }
                                        hl.Keyword = { fg = c.magenta, bold = true }
                                        hl.Statement = { fg = c.purple, bold = true }
                                        hl.String = { fg = c.green }
                                        hl.Number = { fg = c.orange }
                                        hl.Boolean = { fg = c.orange, bold = true }
                                        hl.Constant = { fg = c.cyan, bold = true }
                                        hl.Type = { fg = c.blue, bold = true }
                                        hl.Comment = { fg = c.dark5, italic = true }
                                        hl.Variable = { fg = c.fg }
                                end,
                        })
                        vim.cmd.colorscheme("tokyonight-storm")
                end,
        },
}
