return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	cmd = "CodeCompanion",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{ "<leader>l", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion chat" },
		{ "<leader>l", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to CodeCompanion chat", mode = "x" },
		{ "<leader>k", "<cmd>CodeCompanion<cr>", desc = "Code Companion Inline" },
	},
	config = function()
		require("codecompanion").setup({
			display = {
				diff = {
					enabled = true,
				},
				chat = {
					window = {
						buflisted = true, -- List chat as a buffer.
						width = 0.3,
						position = "right",
						sticky = false,
					},
				},
			},
			strategies = {
				chat = {
					completion_provider = "blink",
					keymaps = {
						clear = {
							modes = { n = "gX" },
							description = "Clear chat",
						},
					},
				},
			},
		})
	end,
}
