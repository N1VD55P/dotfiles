-- Set leader key FIRST before any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("core.options")
require("core.keymaps")
require("custom.diagnostics")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set Python path
vim.g.python3_host_prog = "/usr/bin/python3"

-- Setup plugins
require("lazy").setup({
	-- UI and appearance
	{ import = "custom.plugins.theme" },
	{ import = "custom.plugins.lualine" },
	{ import = "custom.plugins.font" },
	{ import = "custom.plugins.indent" },
	
	-- File navigation and management
	{ import = "custom.plugins.neotree" },
	{ import = "custom.plugins.telescope" },
	{ import = "custom.plugins.harpoon" },
	{ import = "custom.plugins.undotree" },
	
	-- Editor enhancements
	{ import = "custom.plugins.treesitter" },
	{ import = "custom.plugins.autocompletion" },
	{ import = "custom.plugins.misc" },
	{ import = "custom.plugins.replace" },
	
	-- Git integration
	{ import = "custom.plugins.gitsigns" },
	
	-- LSP and development
	{ import = "custom.plugins.mason" },
	{ import = "custom.plugins.lsp-config" },
	{ import = "custom.plugins.none-ls" },
	{ import = "custom.plugins.debugging" },
	
	-- Optional: JSON schemas (if you created this file)
	-- { import = "custom.plugins.schemastore" },
	
	-- Snippets (now empty, but kept for structure)
	-- { import = "core.snippets" },
}, {
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	change_detection = {
		notify = false, -- Don't notify on config changes
	},
})

-- Auto-reload configuration on save
local augroup = vim.api.nvim_create_augroup("ConfigReload", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup,
	pattern = vim.fn.stdpath("config") .. "/**/*.lua",
	callback = function()
		vim.notify("Config reloaded!", vim.log.levels.INFO)
	end,
})
