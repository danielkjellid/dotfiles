-- Highlight, edit, and navigate code
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	version = false,
	lazy = false,
	main = "nvim-treesitter.configs", -- Tell lazy.nvim which module to call setup on
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				-- Avoid the sticky context from growing too much.
				max_lines = 3,
				-- Match the context lines to the source code.
				multiline_threshold = 3,
				-- Disable it when the window is too small.
				min_window_height = 20,
			},
			keys = {
				{
					"[c",
					function()
						-- Jump to previous change when in diffview.
						if vim.wo.diff then
							return "[c"
						else
							vim.schedule(function()
								require("treesitter-context").go_to_context()
							end)
							return "<Ignore>"
						end
					end,
					desc = "Jump to upper context",
					expr = true,
				},
			},
		},
	},
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"fish",
			"gitcommit",
			"html",
			"hyprlang",
			"java",
			"javascript",
			"json",
			"json5",
			"jsonc",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"rasi",
			"regex",
			"rust",
			"scss",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},
		highlight = {
			enable = true,
			priority = 150, -- Higher than LSP semantic tokens (125-127) to ensure treesitter takes precedence
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<cr>",
				node_incremental = "<cr>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		indent = {
			enable = true,
			-- Treesitter unindents Yaml lists for some reason.
			disable = { "yaml" },
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

		-- Ensure treesitter highlighting is started for all buffers
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				-- Start treesitter highlighting if a parser exists for this filetype
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
