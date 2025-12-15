return {
	{
		"EdenEast/nightfox.nvim",
		name = "nightfox",
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true, -- ✅ Enable transparent background
				},
				flavour = "carbonfox", -- Set the theme to Mocha
			})
			vim.cmd.colorscheme("carbonfox") -- Apply the theme
		end,
	},
}
