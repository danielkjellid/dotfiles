-- Surround selections, add quotes, etc.
return {
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		init = function()
			vim.g.nvim_surround_no_mappings = true
		end,
		opts = {},
		config = function(_, opts)
			require("nvim-surround").setup(opts)

			vim.keymap.set("n", "yz", "<Plug>(nvim-surround-normal)")
			vim.keymap.set("n", "yzz", "<Plug>(nvim-surround-normal-cur)")
			vim.keymap.set("n", "yZ", "<Plug>(nvim-surround-normal-line)")
			vim.keymap.set("n", "yZZ", "<Plug>(nvim-surround-normal-cur-line)")
			vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)")
			vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)")
			vim.keymap.set("n", "cS", "<Plug>(nvim-surround-change-line)")
			vim.keymap.set("x", "Z", "<Plug>(nvim-surround-visual)")
		end,
	},
}
