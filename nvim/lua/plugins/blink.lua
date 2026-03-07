-- Auto completion
-- https://github.com/saghen/blink.cmp
return {
	"saghen/blink.cmp",
	build = "cargo +nightly build --release",
	event = "InsertEnter",
	dependencies = {
		"fang2hou/blink-copilot",
	},
	opts = {
		keymap = {
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = {
				function(cmp)
					if cmp.is_visible() then
						return cmp.select_next()
					elseif cmp.snippet_active() then
						return cmp.snippet_forward()
					else
						return -- fallback to next command
					end
				end,
				"fallback",
			},
			["<S-Tab>"] = {
				function(cmp)
					if cmp.is_visible() then
						return cmp.select_prev()
					elseif cmp.snippet_active() then
						return cmp.snippet_backward()
					else
						return true -- prevent fallback (don't insert tab)
					end
				end,
			},
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		},
		completion = {
			ghost_text = { enabled = false }, -- Disable ghost text to allow Copilot to make suggestions.
			list = {
				-- Insert items while navigating the completion list.
				selection = { preselect = false, auto_insert = true },
				max_items = 10,
			},
			documentation = { auto_show = true },
			menu = {
				scrollbar = false,
				draw = {
					gap = 2,
					columns = {
						{ "kind_icon", "kind", gap = 1 },
						{ "label", "label_description", gap = 1 },
					},
				},
			},
		},
		-- Disable command line completion:
		cmdline = { enabled = false },
		sources = {
			-- Disable some sources in comments and strings.
			default = function()
				local sources = { "lsp", "buffer", "copilot" }
				local ok, node = pcall(vim.treesitter.get_node)

				if ok and node then
					if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
						table.insert(sources, "path")
					end
					if node:type() ~= "string" then
						table.insert(sources, "snippets")
					end
				end

				return sources
			end,
			per_filetype = {
				codecompanion = { "codecompanion", "buffer" }, -- CodeCompanion first for tools/variables/slash, buffer as fallback
			},
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
		appearance = {
			kind_icons = require("icons").symbol_kinds,
		},
	},
}
