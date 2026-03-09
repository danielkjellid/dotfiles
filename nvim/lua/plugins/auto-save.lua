return {
	"okuuva/auto-save.nvim",
	version = "^1.0.0",
	cmd = "ASToggle",
	event = { "InsertLeave", "TextChanged" },
	opts = {},
	config = function(_, opts)
		require("auto-save").setup(opts)

		local group = vim.api.nvim_create_augroup("autosave", {})

		vim.api.nvim_create_autocmd("User", {
			pattern = "AutoSaveWritePost",
			group = group,
			callback = function(opts)
				if opts.data.saved_buffer ~= nil then
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(opts.data.saved_buffer), ":.")
					vim.notify("AutoSave: " .. filename, vim.log.levels.INFO)
				end
			end,
		})
	end,
}
