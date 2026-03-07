return {
	"mhartington/formatter.nvim",
	event = "VeryLazy",
	config = function()
		require("formatter").setup({
			filetype = {
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				python = {
					require("formatter.filetypes.python").ruff,
				},
				typescript = {
					require("formatter.filetypes.typescript").biome,
				},
				typescriptreact = {
					require("formatter.filetypes.typescriptreact").biome,
				},
				markdown = {
					require("formatter.filetypes.markdown").prettier,
				},
				["*"] = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})

		local augroup = vim.api.nvim_create_augroup
		local autocmd = vim.api.nvim_create_autocmd

		augroup("__formatter__", { clear = true })
		autocmd("BufWritePost", {
			group = "__formatter__",
			callback = function()
				-- Check if formatting should be skipped (set by <C-S-s> keymap)
				if vim.g.skip_formatting then
					vim.g.skip_formatting = false -- Reset flag for next time
					return
				end
				-- Format normally
				vim.cmd("FormatWrite")
			end,
		})
	end,
}
