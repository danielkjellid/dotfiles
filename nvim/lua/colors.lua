local M = {}

--- Color palette from VS Code theme
M.palette = {
	-- Base colors
	white = "#e1e4e8", -- Main foreground/text
	dark_bg = "#1b1f23", -- Dark background/borders
	dark_bg_alt = "#1f2428", -- Alternative dark background

	-- Grays
	dark_gray = "#444d56", -- Line numbers, non-text
	medium_gray = "#959da5", -- Inactive text, folded
	light_gray = "#d1d5da", -- Status line, punctuation
	comment_gray = "#6a737d", -- Comments

	-- Blues
	cursor_blue = "#c8e1ff", -- Cursor color
	blue = "#79b8ff", -- Constants, diagnostics info
	light_blue = "#9ecbff", -- Strings
	very_light_blue = "#dbedff", -- Regex strings
	darker_blue = "#6a9eff", -- Builtin types

	-- Other colors
	red = "#f97583", -- Keywords, errors
	yellow = "#ffea7f", -- Warnings, todos
	purple = "#b392f0", -- Functions, classes
	green = "#85e89d", -- Tags, special chars
	dark_green = "#66a581", -- Darker green
	orange = "#ffab70", -- Parameters, diff change
	darker_orange = "#ff8b45", -- Darker orange

	-- Git colors
	git_green = "#28a745", -- Git add
	git_blue = "#2188ff", -- Git change
	git_red = "#ea4a5a", -- Git delete
	diff_pink = "#fdaeb7", -- Diff delete
}

return M
