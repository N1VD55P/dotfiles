require("core.keymaps")
require("core.options")
require("custom.diagnostics")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)
vim.g.python3_host_prog = "/usr/bin/python3"

require("lazy").setup({
	{ import = "custom.plugins.neotree" },
	{ import = "custom.plugins.theme" },
	{ import = "custom.plugins.lualine" },
	{ import = "custom.plugins.treesitter" },
	{ import = "custom.plugins.telescope" },
	{ import = "custom.plugins.misc" },
	{ import = "custom.plugins.gitsigns" },
	{ import = "custom.plugins.autocompletion" },
	{ import = "custom.plugins.lsp-config" }, -- LSP import here
	{ import = "core.snippets" },
	{ import = "custom.plugins.undotree" },
	{ import = "custom.plugins.harpoon" },
	{ import = "custom.plugins.none-ls" },
	{ import = "custom.plugins.replace" },
	{ import = "custom.plugins.debugging" },
	{ import = "custom.plugins.font"},
	{ import = "custom.plugins.indent"}
})
