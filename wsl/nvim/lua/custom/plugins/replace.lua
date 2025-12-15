-- File: hellog/nvim/lua/custom/plugins/replace.lua
return {
    "folke/which-key.nvim", -- or any dependency you might need, or empty string "" if none
    config = function()
        -- Function to replace visually selected text with input from floating window
        local function ReplaceVisualSelectionWithPopup()
            -- Get the visually selected text
            local saved_reg = vim.fn.getreg('"')
            vim.cmd('normal! gvy')
            local selected_text = vim.fn.getreg('"')
            vim.fn.setreg('"', saved_reg)
            
            -- Get current window and cursor position
            local win = vim.api.nvim_get_current_win()
            local cursor_pos = vim.api.nvim_win_get_cursor(win)
            local row, col = cursor_pos[1], cursor_pos[2]
            
            -- Create a scratch buffer for the input
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
            
            -- Set up the floating window near cursor position
            local width = 30
            local height = 1
            local opts = {
                relative = 'win',
                win = win,
                row = row - vim.fn.line('w0'),
                col = col + 2,
                width = width,
                height = height,
                style = 'minimal',
                border = 'rounded',
                title = 'Replace with:',
                title_pos = 'left'
            }
            
            -- Create the floating window
            local float_win = vim.api.nvim_open_win(buf, true, opts)
            vim.api.nvim_win_set_option(float_win, 'winhl', 'Normal:PopupWindow')
            
            -- Enter insert mode automatically
            vim.cmd('startinsert')
            
            -- Set up buffer local mappings for the popup
            vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', '', {
                noremap = true,
                callback = function()
                    local input = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
                    vim.api.nvim_win_close(float_win, true)
                    
                    -- Return to normal mode and do the replacement
                    vim.cmd('stopinsert')
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
                    vim.fn.setreg('/', '\\%V.*\\%V.')
                    vim.cmd(string.format('normal! gvc%s', input))
                end
            })
            
            -- Close popup and cancel on escape
            vim.api.nvim_buf_set_keymap(buf, 'i', '<Esc>', '', {
                noremap = true,
                callback = function()
                    vim.api.nvim_win_close(float_win, true)
                    vim.cmd('stopinsert')
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
                end
            })
        end

        -- Map the function to <leader>r in visual mode
        vim.api.nvim_set_keymap("v", "<leader>r", 
            [[<Cmd>lua _G.ReplaceVisualSelectionWithPopup()<CR>]], 
            {noremap = true, silent = true})
        
        -- Make the function available globally
        _G.ReplaceVisualSelectionWithPopup = ReplaceVisualSelectionWithPopup
        
        -- Add highlight group for the popup (optional)
        vim.cmd([[highlight PopupWindow guibg=#1E1E2E]])
    end
}
