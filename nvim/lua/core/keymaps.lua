-- Autocommands: remap Caps Lock for Kitty while in Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.fn.system("kitty @ set-keyboard-mapping caps_lock send_text all \\x1b")
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.fn.system("kitty @ remove-keyboard-mapping caps_lock")
  end,
})

-- Move cursor in insert mode with Ctrl + hjkl
vim.keymap.set("i", "<C-h>", "<Left>",  { noremap = true, silent = true })
vim.keymap.set("i", "<C-j>", "<Down>",  { noremap = true, silent = true })
vim.keymap.set("i", "<C-k>", "<Up>",    { noremap = true, silent = true })
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true })

-- Leader key
vim.g.mapleader = " "

-- LSP restart
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Vim-with-me plugin
vim.keymap.set("n", "<leader>vwm", function() require("vim-with-me").StartVimWithMe() end, { desc = "Start Vim With Me" })
vim.keymap.set("n", "<leader>svwm", function() require("vim-with-me").StopVimWithMe() end, { desc = "Stop Vim With Me" })

-- Disable Ex-mode
vim.keymap.set("n", "Q", "<nop>")

-- Format with LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })

-- Delete without copying (works in normal + visual mode)
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true, silent = true, desc = "Delete without yanking" })

-- Cut to clipboard
vim.keymap.set("v", "<leader>x", '"+d', { noremap = true, silent = true, desc = "Cut to clipboard" })

-- Copy to clipboard
vim.keymap.set("v", "<leader>c", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })

-- Move to start of line
vim.keymap.set({ "n", "v" }, "ls", "^", { noremap = true, silent = true, desc = "Start of line" })

-- Move to end of line
vim.keymap.set({ "n", "v" }, "le", "g_", { noremap = true, silent = true, desc = "End of line" })

-- Replace globally word under cursor
vim.keymap.set("n", "<leader>rg", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace globally" })

-- Replace inside chosen bracket
vim.keymap.set("n", "<leader>rb", function()
  local choice = vim.fn.input("Replace inside (p)arentheses, (s)quare, or (c)urly? ")
  local textobj
  if choice == "p" then
    textobj = "vi("
  elseif choice == "s" then
    textobj = "vi["
  elseif choice == "c" then
    textobj = "vi{"
  else
    vim.notify("Invalid choice: use p/s/c", vim.log.levels.WARN)
    return
  end

  local word = vim.fn.expand("<cword>")
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")

  -- Select inside bracket and substitute
  vim.cmd("normal! " .. textobj)
  vim.cmd([[s/\<]] .. word .. [[\>/]] .. replacement .. [[/gI]])
end, { desc = "Replace inside chosen bracket" })
vim.keymap.set({"n", "i", "v", "o"}, "<CapsLock>", "<Esc>", { noremap = true, silent = true })
