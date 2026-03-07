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
					-- Editor colors
					Normal = { fg = white },
					NormalFloat = { fg = white },
					FloatBorder = { fg = dark_bg },

					-- Cursor and selection
					Cursor = { fg = cursor_blue },

					-- Line numbers
					LineNr = { fg = dark_gray },
					CursorLineNr = { fg = white },

					-- Diagnostics
					DiagnosticError = { fg = red },
					DiagnosticWarn = { fg = yellow },
					DiagnosticInfo = { fg = blue },
					DiagnosticHint = { fg = blue },

					-- Git signs
					GitSignsAdd = { fg = git_green },
					GitSignsChange = { fg = git_blue },
					GitSignsDelete = { fg = git_red },

					-- Status line
					StatusLine = { fg = light_gray },
					StatusLineNC = { fg = medium_gray },

					-- Tab line
					TabLine = { fg = medium_gray },
					TabLineSel = { fg = white },

					-- SnacksPickerListCursorLine = { bg = cursor_blue },

					-- Syntax highlighting
					Comment = { fg = comment_gray, italic = true },
					Constant = { fg = blue },
					String = { fg = light_blue },
					Character = { fg = light_blue },
					Number = { fg = blue },
					Boolean = { fg = blue },
					Float = { fg = blue },

					Identifier = { fg = white },
					Function = { fg = purple },

					Statement = { fg = red },
					Conditional = { fg = red },
					Repeat = { fg = red },
					Label = { fg = red },
					Operator = { fg = white },
					Keyword = { fg = red },
					Exception = { fg = red },

					PreProc = { fg = purple },
					Include = { fg = red },
					Define = { fg = red },
					Macro = { fg = purple },
					PreCondit = { fg = purple },

					Type = { fg = purple }, -- Custom classes (same as functions)
					StorageClass = { fg = red },
					Structure = { fg = purple }, -- Custom structures
					Typedef = { fg = purple }, -- Custom type definitions

					Special = { fg = blue },
					SpecialChar = { fg = green, bold = true },
					Tag = { fg = green },
					Delimiter = { fg = light_gray },
					SpecialComment = { fg = comment_gray },
					Debug = { fg = red },

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

					-- Fold
					Folded = { fg = medium_gray },
					FoldColumn = { fg = dark_gray },

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

					-- Treesitter
					["@comment"] = { fg = comment_gray, italic = true },
					["@constant"] = { fg = blue },
					["@constant.builtin"] = { fg = blue },
					["@constant.macro"] = { fg = light_blue }, -- Enum members (same as variables)
					["@lsp.type.enumMember"] = { fg = light_blue }, -- Enum members (same as variables)
					["@lsp.typemod.member"] = { fg = light_blue }, -- Enum/class members (same as variables)
					["@string"] = { fg = light_blue },
					["@string.regexp"] = { fg = very_light_blue },
					["@string.special"] = { fg = light_blue }, -- Docstrings
					["@string.documentation"] = { fg = light_blue }, -- Docstrings
					["@text.literal"] = { fg = light_blue }, -- Docstrings/literal text
					["@function"] = { fg = purple },
					["@function.builtin"] = { fg = purple },
					["@function.method"] = { fg = purple }, -- Class methods (same as functions)
					["@function.call"] = { fg = purple }, -- Function calls
					["@method"] = { fg = purple }, -- Methods
					["@method.call"] = { fg = purple }, -- Method calls
					["@constructor"] = { fg = darker_blue }, -- Type constructors (int(), str(), etc.)
					["@keyword"] = { fg = red },
					["@keyword.function"] = { fg = red }, -- def keyword
					["@keyword.operator"] = { fg = red }, -- in, not, is, etc.
					["@keyword.export"] = { fg = red }, -- export keyword
					["@keyword.return"] = { fg = red }, -- return keyword
					["@operator"] = { fg = white },
					["@variable"] = { fg = white },
					["@variable.builtin"] = { fg = white },
					["@variable.member"] = { fg = white }, -- Object/class members (same as variables)
					["@parameter"] = { fg = orange },
					["@parameter.reference"] = { fg = orange },
					["@variable.parameter"] = { fg = orange },
					["@type"] = { fg = darker_blue }, -- Type annotations (builtin types)
					["@namespace"] = { fg = purple }, -- Module imports (same as functions)
					["@type.builtin"] = { fg = darker_blue }, -- Builtin types (darker blue) - must come after function groups

					-- LSP semantic tokens: Link to treesitter groups to retain original colors
					-- This ensures LSP tokens enhance rather than override treesitter highlighting
					-- Function-related tokens must link to @function (not @variable)
					-- ["@lsp.type.function"] = { link = "@function" }, -- Functions -> function color (purple)
					-- ["@lsp.typemod.function"] = { link = "@function" }, -- Function modifiers -> function color
					-- ["@lsp.typemod.function.declaration"] = { link = "@function" }, -- Function declarations -> function color
					-- ["@lsp.typemod.function.local"] = { link = "@function" }, -- Local functions -> function color
					-- ["@lsp.typemod.function.readonly"] = { link = "@function" }, -- Readonly functions -> function color
					-- ["@lsp.typemod.function.member"] = { link = "@function" }, -- Function members -> function color (purple)
					-- ["@lsp.type.method"] = { link = "@method" }, -- Methods -> method color (purple)
					-- ["@lsp.type.class"] = { link = "@type" }, -- Classes -> type color
					-- ["@lsp.typemod.class.builtin"] = { link = "@type.builtin" }, -- Builtin classes -> builtin type color
					-- ["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" }, -- Default library classes -> builtin type color
					-- ["@lsp.mod.builtin"] = { link = "@namespace" }, -- Builtin modules -> namespace color
					-- ["@lsp.mod.defaultLibrary"] = { link = "@namespace" }, -- Default library modules -> namespace color
					-- -- Keep specific modifiers that don't conflict
					-- ["@lsp.mod.local"] = { link = "@variable" }, -- Local variables -> variable color
					-- ["@lsp.mod.readonly"] = { link = "@variable" }, -- Readonly variables -> variable color
					-- ["@lsp.type.variable"] = { link = "@variable" }, -- Variables -> variable color
					-- ["@lsp.type.constant"] = { link = "@constant" }, -- Constants -> constant color
					-- ["@lsp.type.property"] = { link = "@variable.member" }, -- Properties -> variable.member
					-- ["@lsp.type.enum"] = { link = "@type" }, -- Enums -> type color
					-- ["@lsp.type.enumMember"] = { link = "@constant" }, -- Enum members -> constant color
					-- ["@lsp.type.parameter"] = { link = "@parameter" }, -- Parameters -> parameter color
					-- -- Language-specific parameter semantic tokens (higher priority, must override)
					-- ["@lsp.type.parameter.python"] = { link = "@parameter" }, -- Python parameters -> orange
					-- ["@lsp.mod.parameter.python"] = { link = "@parameter" }, -- Python parameter modifiers -> orange
					-- ["@lsp.typemod.parameter.parameter.python"] = { link = "@parameter" }, -- Python parameter type modifiers -> orange
					-- -- Override declaration modifiers specifically for Python parameters (must come after generic ones)
					-- ["@lsp.typemod.parameter.declaration.python"] = { link = "@parameter" }, -- Python parameter declarations -> orange (overrides @variable)
					-- ["@lsp.type.type"] = { link = "@type" }, -- Types -> type color
					-- ["@lsp.type.namespace"] = { link = "@namespace" }, -- Namespaces -> namespace color
					-- ["@lsp"] = { link = "@variable" }, -- Fallback: generic LSP -> variable color
					["@module"] = { fg = purple }, -- Module imports (same as functions)
					["@tag"] = { fg = green },
					["@tag.builtin"] = { fg = green }, -- Built-in HTML tags
					["@punctuation"] = { fg = light_gray },
					["@punctuation.bracket"] = { fg = light_gray },
					["@punctuation.delimiter"] = { fg = light_gray },
					["@error"] = { fg = red },
					["@warning"] = { fg = yellow },
					["@text.emphasis"] = { italic = true },
					["@text.strong"] = { bold = true },
					["@text.underline"] = { underline = true },
					["@text.strike"] = { strikethrough = true },

					-- JSX/TSX: Make component names purple (like @function) since they are functions
					-- This ensures consistent purple coloring for JSX elements
					["@tag.tsx"] = { link = "@function" }, -- JSX component names -> purple (functions)
					["@tag.jsx"] = { link = "@function" },
					["@tag.javascriptreact"] = { link = "@function" },
					["@tag.typescriptreact"] = { link = "@function" },
					["@_jsx_element.tsx"] = { link = "@function" }, -- JSX element nodes -> purple
					-- JSX props/attributes: Color like function arguments (orange)
					["@tag.attribute.tsx"] = { link = "@parameter" }, -- JSX attributes -> orange (like function args)
					["@tag.attribute.jsx"] = { link = "@parameter" },
					["@tag.attribute.javascriptreact"] = { link = "@parameter" },
					["@tag.attribute.typescriptreact"] = { link = "@parameter" },
					["@_jsx_attribute.tsx"] = { link = "@parameter" }, -- JSX attribute nodes -> orange
					["@variable.member.tsx"] = { link = "@parameter" }, -- JSX prop names -> orange
					-- Keep builtin HTML tags as green
					["@tag.builtin.tsx"] = { link = "@tag.builtin" },
					["@tag.builtin.jsx"] = { link = "@tag.builtin" },
					["@tag.builtin.javascriptreact"] = { link = "@tag.builtin" },
					["@tag.builtin.typescriptreact"] = { link = "@tag.builtin" },
				}
			end,
		})
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
