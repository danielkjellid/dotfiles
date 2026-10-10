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
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move down" })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move up" })

-- Commenting.
vim.keymap.set("v", "<leader>c", "gcgv", { remap = true, desc = "Toggle comment" })
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Toggle comment" })

-- Switch between windows.
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the bottom window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the top window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the right window", remap = true })

-- Quickly go to the end of the line while in insert mode.
vim.keymap.set({ "i", "c" }, "<C-l>", "<C-o>A", { desc = "Go to the end of the line" })
vim.keymap.set({ "i", "c" }, "<C-h>", "<C-o>S", { desc = "Go to the beginning of the line" })

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
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition({
		on_list = function(opts)
			local items = opts.items or {}
			local unique = {}
			local seen = {}
			for _, item in ipairs(items) do
				local key = string.format("%s:%d:%d", item.filename or "", item.lnum or 0, item.col or 0)
				if not seen[key] then
					seen[key] = true
					unique[#unique + 1] = item
				end
			end
			if #unique <= 1 then
				vim.fn.setqflist({}, " ", { title = opts.title, items = unique, context = opts.context })
				vim.cmd("cfirst")
			else
				Snacks.picker.lsp_definitions()
			end
		end,
	})
end, { desc = "Go to definition" })
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Show signature help" })
vim.keymap.set("n", "gl", function()
	local ft = vim.bo.filetype
	if ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
		require("rulebook").prettifyError()
	else
		vim.diagnostic.open_float()
	end
end, { desc = "Show diagnostic information" })

vim.api.nvim_create_user_command("Messages", function()
	Snacks.notifier.show_history()
end, { desc = "Show notification history" })
