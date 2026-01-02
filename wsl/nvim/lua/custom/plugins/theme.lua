return {
	{
		"EdenEast/nightfox.nvim",
		name = "nightfox",
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = false, 
				},
				flavour = "duskfox",
			})
			vim.cmd.colorscheme("duskfox") -- Apply the theme
		end,
	},
}
