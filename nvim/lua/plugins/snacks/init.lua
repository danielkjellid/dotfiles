local picker = require("plugins.snacks.picker")
local explorer = require("plugins.snacks.explorer")
local notifier = require("plugins.snacks.notifier")

return {
	"folke/snacks.nvim",
	lazy = false,
	opts = {
		picker = picker.config,
		explorer = explorer.config,
		notifier = notifier.config,
	},
	config = function(_, opts)
		local snacks = require("snacks")
		snacks.setup(opts)

		-- Configure explorer behavior
		explorer.configure(snacks)
	end,
	keys = {
		{
			"<leader>p",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart find files",
		},
		{
			"<leader>b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>f",
			function()
				Snacks.picker.grep()
			end,
			desc = "Find anything (live grep)",
		},
		{
			"<leader>f",
			function()
				local sel = Snacks.picker.util.visual()
				Snacks.picker.grep({ search = sel and sel.text or "" })
			end,
			mode = "x",
			desc = "Grep visual selection",
		},
		{
			"<leader>e",
			function()
				explorer.snacks_explorer_focus()
			end,
			desc = "Switch focus between Explorer and Buffer",
		},
		{
			"<leader>E",
			function()
				explorer.snacks_explorer_toggle()
			end,
			desc = "Toggle File Explorer",
		},
		{
			"<leader>.",
			function()
				vim.lsp.buf.code_action()
			end,
			desc = "Quick fix (code actions)",
		},
	},
}
