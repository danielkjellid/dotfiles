-- Custom start screen for neovim.
-- https://github.com/mhinz/vim-startify
return {
	"mhinz/vim-startify",
	config = function()
		vim.g.startify_custom_header = vim.fn["startify#pad"]({
			"     _             _      _ _     _      _ _ _     _",
			"  __| | __ _ _ __ (_) ___| | | __(_) ___| | (_) __| |",
			" / _` |/ _` | '_ \\| |/ _ \\ | |/ /| |/ _ \\ | | |/ _` |",
			"| (_| | (_| | | | | |  __/ |   < | |  __/ | | | (_| |",
			" \\__,_|\\__,_|_| |_|_|\\___|_|_|\\_\\/ |\\___|_|_|_|\\__,_|",
			"                               |__/                  ",
		})

		-- Bookmarks: vim-startify expects a list of paths (strings)
		-- It will use the directory basename as the label
		vim.g.startify_bookmarks = {
			vim.env.HOME .. "/code",
			vim.env.HOME .. "/code/tienda/tienda",
			vim.env.HOME .. "/code/tienda/tienda-web",
			vim.env.HOME .. "/.zshrc",
			vim.fn.stdpath("config"),
		}
	end,
}
