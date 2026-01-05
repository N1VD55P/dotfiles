return {
	{
		"theprimeagen/harpoon",
		lazy = false,
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon"):setup()
		end,
		keys = {
			{
				"<leader>ha",
				function()
					local harpoon = require("harpoon")
					local list = harpoon:list()

					if #list.items >= 5 then
						vim.notify("Harpoon list is full (max 5 files)", vim.log.levels.WARN)
						return
					end

					list:append()
				end,
				desc = "harpoon file (max 5)",
			},
			{
				"<leader>h",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "harpoon quick menu",
			},
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "harpoon to file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "harpoon to file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "harpoon to file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "harpoon to file 4",
			},
			{
				"<leader>5",
				function()
					require("harpoon"):list():select(5)
				end,
				desc = "harpoon to file 5",
			},
			{
				"<leader>Hd",
				function()
					local harpoon = require("harpoon")
					harpoon:list():remove()
				end,
				desc = "remove file from harpoon",
			},
		},
	},
}
