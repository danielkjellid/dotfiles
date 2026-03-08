local icons = require("icons")

local M = {}

---@type table<string, boolean>
local hl_cache = {}

--- Like statusline.get_or_create_hl but handles nil fg/bg gracefully.
--- Only caches after a successful creation.
---@param hl string
---@return string
local function get_or_create_hl(hl)
	if hl_cache[hl] then
		return "Winbar" .. hl
	end

	local bg_hl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
	local fg_hl = vim.api.nvim_get_hl(0, { name = hl, link = false })

	if not bg_hl.bg or not fg_hl.fg then
		return "StatusLine"
	end

	local hl_name = "Winbar" .. hl
	vim.api.nvim_set_hl(0, hl_name, { bg = ("#%06x"):format(bg_hl.bg), fg = ("#%06x"):format(fg_hl.fg) })
	hl_cache[hl] = true

	return hl_name
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("winbar_highlights", { clear = true }),
	callback = function()
		hl_cache = {}
	end,
})

local exclude_filetypes = {
	"DiffviewFileHistory",
	"DiffviewFiles",
	"ccc-ui",
	"dap-view",
	"grug-far",
	"codecompanion",
	"fzf",
	"gitcommit",
	"gitrebase",
	"help",
	"lazy",
	"lazyterm",
	"minifiles",
	"qf",
	"snacks_layout_box",
	"snacks_notif",
	"snacks_picker_input",
	"snacks_picker_list",
	"snacks_picker_preview",
	"startify",
}

---@param bufnr integer
---@return string?
local function get_file_git_hl(bufnr)
	local status = vim.b[bufnr].gitsigns_status_dict
	if not status then
		return nil
	end

	local added = status.added or 0
	local changed = status.changed or 0
	local removed = status.removed or 0

	if added + changed + removed > 0 then
		return "SnacksPickerGitStatusModified"
	end

	return nil
end

---@return string
function M.render()
	local winid = vim.g.statusline_winid
	local bufnr = vim.api.nvim_win_get_buf(winid)

	local ft = vim.bo[bufnr].filetype
	for _, excluded in ipairs(exclude_filetypes) do
		if ft == excluded then
			return ""
		end
	end

	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	if buf_name == "" then
		return ""
	end

	local cwd = vim.fn.getcwd()
	local relative_path = vim.fn.fnamemodify(buf_name, ":~:.")
	if not vim.startswith(buf_name, cwd) then
		relative_path = vim.fn.fnamemodify(buf_name, ":~")
	end

	local parts = vim.split(relative_path, "/", { plain = true })
	if #parts == 0 then
		return ""
	end

	local separator_hl = get_or_create_hl("NonText")
	local separator = string.format(" %%#%s#%s ", separator_hl, icons.angles.right)

	local dir_hl = get_or_create_hl("SnacksPickerDirectory")

	local segments = {}
	for i, part in ipairs(parts) do
		if i < #parts then
			table.insert(segments, string.format("%%#%s#%s", dir_hl, part))
		else
			local git_hl = get_file_git_hl(bufnr)
			local hl = git_hl and get_or_create_hl(git_hl) or "StatusLine"
			local modified = vim.bo[bufnr].modified and "*" or ""
			table.insert(segments, string.format("%%#%s#%s%s", hl, part, modified))
		end
	end

	return string.format("%%#StatusLine# %s%%#StatusLine#%%=", table.concat(segments, separator))
end

local winbar_expr = "%!v:lua.require'winbar'.render()"

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "FileType" }, {
	group = vim.api.nvim_create_augroup("winbar_manage", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype
		local is_excluded = false
		for _, excluded in ipairs(exclude_filetypes) do
			if ft == excluded then
				is_excluded = true
				break
			end
		end

		local value = is_excluded and "" or winbar_expr
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
				vim.wo[win].winbar = value
			end
		end
	end,
})

return M
