local explorer = require("plugins.snacks.explorer")

local M = {
	config = {
		ui_select = true,
		matcher = {
			fuzzy = true,
			smartcase = true,
			filename_bonus = true,
			file_pos = true,
		},
		sources = {
			grep = {
				args = {
					-- Support special characters in the search query.
					"--fixed-strings",
				},
			},
			explorer = explorer.picker_source_config,
			buffers = {
				win = {
					input = {
						keys = {
							["<leader>bd"] = { "bufdelete", mode = { "n", "i" } },
							["dd"] = { "bufdelete", mode = { "n" } },
							["|"] = { "vsplit", mode = { "n" } },
							["_"] = { "split", mode = { "n" } },
							["<a-a>"] = {
								"sidekick_send",
								mode = { "n", "i" },
							},
						},
					},
					list = {
						keys = {
							["dd"] = { "bufdelete", mode = { "n" } },
							["|"] = { "vsplit", mode = { "n" } },
							["_"] = { "split", mode = { "n" } },
						},
					},
				},
			},
		},
	},
}

return M
