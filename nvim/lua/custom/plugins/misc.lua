 -- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  
   },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- Notification UI used by Noice
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
      require('notify').setup({
        stages = 'fade',
        timeout = 2000,
        max_height = 10,
        max_width = 70,
        render = 'wrapped-compact',
        minimum_width = 20,
      })
    end,
  },
  {
    -- Command line in a rounded floating box
    'folke/noice.nvim',
    event = 'VimEnter',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    config = function()
      require('noice').setup({
        cmdline = {
          enabled = true,
          view = 'cmdline_popup',
        },
        popupmenu = {
          enabled = true,
          backend = 'nui',
        },
        presets = {
          command_palette = true,
          bottom_search = false,
          long_message_to_split = true,
          inc_rename = false,
        },
        views = {
          cmdline_popup = {
            position = {
              row = '40%',
              col = '50%',
            },
            size = {
              width = 56,
              height = 3,
            },
            border = {
              style = 'rounded',
              padding = { 0, 2 },
            },
            win_options = {
              winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
            },
          },
        },
      })
    end,
  },
 
}

