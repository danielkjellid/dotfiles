
-- -- Disable netrw.
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- File explorer for neovim.
-- https://github.com/nvim-tree/nvim-tree.lua
return {
  -- 'nvim-tree/nvim-tree.lua',
  -- dependencies = {
  --   'nvim-tree/nvim-web-devicons',
  -- },
  -- config = function()
  --   require('nvim-tree').setup({
  --     view = {
  --       width = vim.g.sidebar_width,
  --       side = 'left',
  --     },
  --     filters = {
  --       enable = false
  --     }
  --   })

  --   -- Open nvim-tree when opening a file
  --   vim.api.nvim_create_autocmd('VimEnter', {
  --     callback = function(data)
  --       -- Skip if no file argument was provided
  --       if data.file == '' then
  --         return
  --       end

  --       -- Check if the argument is a directory or a file
  --       local is_directory = vim.fn.isdirectory(data.file) == 1
  --       local is_file = vim.fn.filereadable(data.file) == 1
  --       local api = require('nvim-tree.api')

  --       if is_directory then
  --         vim.cmd.cd(data.file)
  --         api.tree.open()
  --       elseif is_file then
  --         -- Open tree based on current working directory (where nvim was executed from)
  --         api.tree.open({ focus = false })
  --         -- Find and highlight the file in the tree (will expand tree to show it)
  --         vim.defer_fn(function()
  --           api.tree.find_file({ open = true, update_root = false })
  --         end, 100)
  --       end
  --     end,
  --   })

  --   -- Reveal current file in tree when switching buffers
  --   vim.api.nvim_create_autocmd('BufEnter', {
  --     callback = function()
  --       local api = require('nvim-tree.api')
  --       local bufname = vim.api.nvim_buf_get_name(0)
  --       if bufname ~= '' and vim.fn.filereadable(bufname) == 1 then
  --         -- Only reveal if tree is open
  --         if api.tree.is_tree_buf(0) == false then
  --           api.tree.find_file({ open = false, update_root = false })
  --         end
  --       end
  --     end,
  --   })

  --   -- Close nvim-tree if its the last window.
  --   vim.api.nvim_create_autocmd('QuitPre', {
  --     callback = function()
  --       local tree_wins = {}
  --       local floating_wins = {}
  --       local wins = vim.api.nvim_list_wins()

  --       for _, win in ipairs(wins) do
  --         local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
  --         if bufname:match('NvimTree_') ~= nil then
  --           table.insert(tree_wins, win)
  --         end

  --         if vim.api.nvim_win_get_config(win).relative ~= '' then
  --           table.insert(floating_wins, win)
  --         end
  --       end

  --       if #wins - #floating_wins - #tree_wins == 1 then
  --         -- Last window besides nvim-tree, close the tree.
  --         for _, win in ipairs(tree_wins) do
  --           vim.api.nvim_win_close(win, true)
  --         end
  --       end
  --     end,
  --   })
  -- end,
}
