-- Config is heavily inspired by MariaSolOs: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/

-- Global variables
vim.g.projects_dir = vim.env.HOME .. '/code'
vim.g.work_projects_dir = vim.env.HOME .. '/volumes/git'
vim.g.sidebar_width = 30 -- Width for nvim-tree and bufferline sidebar offset

-- Install Lazy.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- General setup
require 'settings'
require 'keymaps'
require 'statusline'
require 'lsp'

---@type LazySpec
local plugins = 'plugins'


-- Configure plugins.
require('lazy').setup(plugins, {
  ui = { border = 'rounded' },
  dev = { path = vim.g.projects_dir },
  install = {
    -- Do not automatically install on startup.
    missing = true,
  },
  -- Don't bother me when tweaking plugins.
  change_detection = { notify = false },
  -- None of my plugins use luarocks so disable this.
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- Stuff I don't use.
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'zipPlugin',
      },
    },
  },
})

-- Interactive textual undotree:
-- vim.cmd.packadd 'nvim.undotree'
