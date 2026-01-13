-- Autocommands: remap Caps Lock for Kitty while in Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check if running in Kitty terminal
    if vim.env.TERM == "xterm-kitty" then
      vim.fn.system("kitty @ set-keyboard-mapping caps_lock send_text all \\x1b")
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    if vim.env.TERM == "xterm-kitty" then
      vim.fn.system("kitty @ remove-keyboard-mapping caps_lock")
    end
  end,
})

-- Leader key (set this FIRST before any leader mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better navigation in insert mode
vim.keymap.set("i", "<C-h>", "<Left>",  { noremap = true, silent = true, desc = "Move left in insert mode" })
vim.keymap.set("i", "<C-j>", "<Down>",  { noremap = true, silent = true, desc = "Move down in insert mode" })
vim.keymap.set("i", "<C-k>", "<Up>",    { noremap = true, silent = true, desc = "Move up in insert mode" })
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true, desc = "Move right in insert mode" })

-- LSP restart
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Disable Ex-mode
vim.keymap.set("n", "Q", "<nop>")

-- Format with LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })

-- Better delete (without yanking to default register)
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true, silent = true, desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { noremap = true, silent = true, desc = "Delete to end without yanking" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { noremap = true, silent = true, desc = "Change without yanking" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { noremap = true, silent = true, desc = "Change to end without yanking" })

-- Cut to clipboard (actual cut)
vim.keymap.set("v", "<leader>x", '"+d', { noremap = true, silent = true, desc = "Cut to clipboard" })
vim.keymap.set("n", "<leader>x", '"+dd', { noremap = true, silent = true, desc = "Cut line to clipboard" })

-- Copy to clipboard
vim.keymap.set("v", "<leader>c", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>c", '"+yy', { noremap = true, silent = true, desc = "Copy line to clipboard" })

-- Paste from clipboard
vim.keymap.set({ "n", "v" }, "<leader>v", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })

-- Move to start/end of line
vim.keymap.set({ "n", "v" }, "ls", "^", { noremap = true, silent = true, desc = "Start of line" })
vim.keymap.set({ "n", "v" }, "le", "g_", { noremap = true, silent = true, desc = "End of line" })

-- Better window navigation (without tmux conflict)
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows with arrows
vim.keymap.set("n", "<C-S-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-S-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-S-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-S-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move text up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Better buffer navigation
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Quick save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all without saving" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

-- Replace globally word under cursor
vim.keymap.set("n", "<leader>rg", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word globally" })

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
  
  if replacement == "" then
    vim.notify("Replacement cancelled", vim.log.levels.INFO)
    return
  end

  -- Select inside bracket and substitute
  vim.cmd("normal! " .. textobj)
  vim.cmd([[s/\<]] .. word .. [[\>/]] .. replacement .. [[/gI]])
end, { desc = "Replace inside chosen bracket" })

-- Better terminal mode mappings
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move to left window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move to bottom window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move to top window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move to right window" })

-- Caps Lock as Escape (fallback if Kitty mapping doesn't work)
vim.keymap.set({"n", "i", "v", "o"}, "<CapsLock>", "<Esc>", { noremap = true, silent = true })
