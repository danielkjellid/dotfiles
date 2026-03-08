-- The colorscheme configuration I use.
-- https://github.com/catppuccin/nvim
return {
	"catppuccin/nvim",
	name = "catppuccin",
	event = "VimEnter",
	priority = 1000,
	config = function()
		local colors_module = require("colors")

		require("catppuccin").setup({
			custom_highlights = function(catppuccin_colors)
				-- Access colors directly from palette
				local colors = colors_module.palette

				-- Get statusline_bg from catppuccin (only color that depends on catppuccin)
				local statusline_bg = catppuccin_colors and (catppuccin_colors.mantle or catppuccin_colors.base)
					or colors.dark_bg

				-- Extract color variables for easier use
				local white = colors.white
				local dark_bg = colors.dark_bg
				local dark_bg_alt = colors.dark_bg_alt
				local cursor_blue = colors.cursor_blue
				local dark_gray = colors.dark_gray
				local medium_gray = colors.medium_gray
				local light_gray = colors.light_gray
				local comment_gray = colors.comment_gray

				local red = colors.red
				local yellow = colors.yellow
				local blue = colors.blue
				local light_blue = colors.light_blue
				local very_light_blue = colors.very_light_blue
				local darker_blue = colors.darker_blue
				local purple = colors.purple
				local green = colors.green
				local orange = colors.orange

				local git_green = colors.git_green
				local git_blue = colors.git_blue
				local git_red = colors.git_red
				local diff_pink = colors.diff_pink

				return {
					-- Cursor and selection
					Cursor = { fg = cursor_blue },

					-- Line numbers
					LineNr = { fg = dark_gray },
					CursorLineNr = { fg = orange, bold = true },

					-- Diagnostics
					DiagnosticError = { fg = red },
					DiagnosticWarn = { fg = yellow },
					DiagnosticInfo = { fg = blue },
					DiagnosticHint = { fg = blue },

					-- Git signs
					GitSignsAdd = { fg = git_green },
					GitSignsChange = { fg = git_blue },
					GitSignsDelete = { fg = git_red },

					-- Snacks picker git status (link to GitSigns instead of Diagnostics)
					SnacksPickerGitStatusAdded = { link = "GitSignsAdd" },
					SnacksPickerGitStatusModified = { link = "GitSignsChange" },
					SnacksPickerGitStatusDeleted = { link = "GitSignsDelete" },
					SnacksPickerGitStatusStaged = { link = "GitSignsAdd" },
					SnacksPickerGitStatusUnmerged = { link = "GitSignsDelete" },

					-- Status line
					StatusLine = { fg = light_gray },
					StatusLineNC = { fg = medium_gray },

					-- Tab line
					TabLine = { fg = medium_gray },
					TabLineSel = { fg = white },

					Underlined = { underline = true },
					Bold = { bold = true },
					Italic = { italic = true },

					Ignore = { fg = comment_gray },
					Error = { fg = red },
					Todo = { fg = yellow, bold = true },

					-- Diff
					DiffAdd = { fg = green },
					DiffChange = { fg = orange },
					DiffDelete = { fg = diff_pink },

					-- Pmenu (completion menu)
					Pmenu = { fg = white },
					PmenuSel = { fg = white },

					-- Wild menu
					WildMenu = { fg = white },

					-- Vert split
					VertSplit = { fg = dark_bg },

					-- Non-text
					NonText = { fg = dark_gray },
					Whitespace = { fg = dark_gray },

					-- Match brackets
					MatchParen = { fg = cursor_blue, bold = true },

					-- Terminal
					Terminal = { fg = light_gray },

					Normal = { fg = white },
					NormalFloat = { fg = white },
					FloatBorder = { fg = dark_bg },

					Constant = { fg = blue },
					Type = { fg = darker_blue }, -- class, enum, interface, type, str, etc.
					Operator = { fg = red },
					Variable = { fg = white },
					Include = { fg = red }, -- import, from
					String = { fg = light_blue },
					Function = { fg = purple },
					Keyword = { fg = red },
					Number = { fg = blue },
					Float = { fg = blue },
					Boolean = { fg = blue },
					Repeat = { fg = red }, -- while, for
					Conditional = { fg = red }, -- if, elif, else
					Exception = { fg = red }, -- try, except, finally
					Special = { fg = blue }, -- _, :, etc.

					-- Treesitter
					["@type.builtin"] = { link = "@type" },
					["@variable.parameter"] = { fg = orange },
					["@variable.builtin"] = { fg = orange },
					["@variable.member"] = { link = "@variable" },
					["@keyword.function"] = { link = "@keyword" },
					["@keyword.return"] = { link = "@keyword" },
					["@keyword.operator"] = { link = "@keyword" },
					["@string.documentation"] = { link = "@string" },
					["@constant.builtin"] = { link = "@constant" },
					["@function.builtin"] = { link = "@type" },
					["@punctuation"] = { link = "@normal" },
					["@punctuation.bracket"] = { link = "@normal" },
					["@punctuation.delimiter"] = { link = "@normal" },
					["@punctuation.special"] = { link = "@normal" },
					["@punctuation.special"] = { link = "@normal" },

					-- Treesitter: Python
					["@constructor.python"] = { link = "@fucntion" },

					-- Treesitter: ts/js/tsx/jsx
					["@punctuation.special.tsx"] = { fg = red },
					["@constructor.tsx"] = { link = "@type" },
					["@variable.builtin.tsx"] = { fg = blue },
					["@tag.tsx"] = { fg = blue },
					["@tag.builtin.tsx"] = { fg = green },
					["@tag.attribute.tsx"] = { fg = purple },
				}
			end,
		})
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
