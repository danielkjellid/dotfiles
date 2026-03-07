-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    vim.notify("Nvim tree not found, skipping")
    return
end

nvim_tree.setup({})
