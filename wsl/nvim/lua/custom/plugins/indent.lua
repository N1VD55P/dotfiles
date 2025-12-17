return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    -- Define rainbow colors (adjust for your theme)
    local colors = {
      "#E06C75", -- red
      "#E5C07B", -- yellow
      "#98C379", -- green
      "#56B6C2", -- cyan
      "#61AFEF", -- blue
      "#C678DD", -- purple
    }

    -- Apply highlight groups BEFORE setup()
    for i, color in ipairs(colors) do
      vim.api.nvim_set_hl(0, "IndentRainbow" .. i, { fg = color })
    end

    require("ibl").setup({
      indent = {
        char = "│",
        highlight = {
          "IndentRainbow1",
          "IndentRainbow2",
          "IndentRainbow3",
          "IndentRainbow4",
          "IndentRainbow5",
          "IndentRainbow6",
        },
      },
      scope = {
        enabled = true,
        highlight = {
          "IndentRainbow1",
          "IndentRainbow2",
          "IndentRainbow3",
          "IndentRainbow4",
          "IndentRainbow5",
          "IndentRainbow6",
        },
        show_start = false,
        show_end = false,
      },
    })
  end,
}
