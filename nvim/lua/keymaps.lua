-- Leader key
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap and adding jumps to the jumplist.
vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

-- Indent while remaining in visual mode.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Navigate buffers.
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Move selected lines while remaining in visual mode.
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", { desc = "Move up" })
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move down" })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", { desc = "Move up" })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move down" })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move up" })

-- Commenting.
vim.keymap.set("v", "<leader>c", "gcgv", { remap = true, desc = "Toggle comment" })
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Toggle comment" })

-- Open the package manager.
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Switch between windows.
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the bottom window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the top window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the right window", remap = true })

-- Quickly go to the end of the line while in insert mode.
vim.keymap.set({ "i", "c" }, "<C-l>", "<C-o>A", { desc = "Go to the end of the line" })

-- Escape and save changes.
vim.keymap.set({ "s", "i", "n", "v" }, "<D-s>", function()
	-- Only save if buffer is writable
	if vim.bo.buftype == "" and vim.bo.modifiable then
		vim.cmd("w")
	end
end, { desc = "Exit insert mode and save changes" })
-- Save without formatting (Ctrl+Shift+S - requires Kitty config)
vim.keymap.set({ "s", "i", "n", "v" }, "<D-S-s>", function()
	-- Only save if buffer is writable
	if vim.bo.buftype == "" and vim.bo.modifiable then
		vim.g.skip_formatting = true
		vim.cmd("w")
	end
end, { desc = "Save without formatting" })

-- Make U opposite to u.
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Diagnostics navigation.
vim.keymap.set("n", "<leader>d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>D", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })

-- LSP.
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Show signature help" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic information" })

vim.api.nvim_create_user_command("Messages", function()
	Snacks.notifier.show_history()
end, { desc = "Show notification history" })
