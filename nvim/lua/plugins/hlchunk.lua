-- Highlight chunks of code in the buffer.
-- https://github.com/shellRaining/hlchunk.nvim
return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local colors = require("colors").palette
		require("hlchunk").setup({
			chunk = {
				-- style consits of two colors, one for normal and one for error.
				style = {
					colors.light_blue,
					colors.red,
				},
				chars = {
					right_arrow = "─",
				},
				enable = true,
				duration = 0,
				delay = 0,
				error_sign = true,
			},
		})
	end,
}
