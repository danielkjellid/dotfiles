vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use an indentation of 4 spaces by default, but allow overrides in ftplugin.
vim.o.sw = 4
vim.o.ts = 4
vim.o.et = true

-- Show whitespace.
vim.opt.list = true
vim.opt.listchars = { space = "⋅", trail = "⋅", tab = "  ↦" }

-- Show line numbers.
vim.wo.number = true
vim.wo.numberwidth = 4 -- Width of the number column (adds padding/offset)
vim.wo.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

-- Disable relative line numbers in insert mode.
vim.api.nvim_create_autocmd("InsertEnter", { command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { command = [[set relativenumber]] })

-- Use rounded borders for floating windows.
vim.o.winborder = "rounded"

-- Sync clipboard between the OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Save undo history.
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or the search has capitals.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Completion.
vim.opt.wildignore:append({ ".DS_Store" })
vim.o.completeopt = "menuone,noselect,noinsert"
vim.o.pumheight = 15

-- Status line.
vim.o.laststatus = 3
vim.o.cmdheight = 1

-- Disable soft wrapping.
vim.opt.wrap = false
