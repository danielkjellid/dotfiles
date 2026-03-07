local icons = require("icons")
local colors = require("colors").palette

local M = {}

-- Don't show the command that produced the quickfix list.
vim.g.qf_disable_statusline = 1

-- Show the mode in my custom component instead.
vim.o.showmode = false

--- Keeps track of the highlight groups I've already created.
---@type table<string, boolean>
local statusline_hls = {}

--- Setup mode highlight groups with colored backgrounds
local function setup_mode_highlights()
	local statusline_bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
	local statusline_bg_str = statusline_bg and ("#%06x"):format(statusline_bg) or colors.dark_bg

	-- Mode color mappings
	local mode_colors = {
		Normal = nil,
		Visual = colors.darker_orange,
		Insert = colors.darker_blue,
		Command = colors.purple,
		Pending = colors.red,
		Other = nil,
	}

	-- Create highlight groups for each mode
	for mode_name, bg_color in pairs(mode_colors) do
		local hl_name = "StatuslineMode" .. mode_name
		-- Use white text on colored background for good contrast
		vim.api.nvim_set_hl(0, hl_name, {
			bg = bg_color,
			fg = colors.white,
		})
	end
end

-- Setup mode highlights on startup
setup_mode_highlights()

---@param hl string
---@return string
function M.get_or_create_hl(hl)
	local hl_name = "Statusline" .. hl

	if not statusline_hls[hl] then
		-- If not in the cache, create the highlight group using the icon's foreground color
		-- and the statusline's background color.
		local bg_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
		local fg_hl = vim.api.nvim_get_hl(0, { name = hl })
		vim.api.nvim_set_hl(0, hl_name, { bg = ("#%06x"):format(bg_hl.bg), fg = ("#%06x"):format(fg_hl.fg) })
		statusline_hls[hl] = true
	end

	return hl_name
end

--- Current mode.
---@return string
function M.mode_component()
	-- Note that: \19 = ^S and \22 = ^V.
	local mode_to_str = {
		["n"] = "NORMAL",
		["no"] = "OP-PENDING",
		["nov"] = "OP-PENDING",
		["noV"] = "OP-PENDING",
		["no\22"] = "OP-PENDING",
		["niI"] = "NORMAL",
		["niR"] = "NORMAL",
		["niV"] = "NORMAL",
		["nt"] = "NORMAL",
		["ntT"] = "NORMAL",
		["v"] = "VISUAL",
		["vs"] = "VISUAL",
		["V"] = "VISUAL",
		["Vs"] = "VISUAL",
		["\22"] = "VISUAL",
		["\22s"] = "VISUAL",
		["s"] = "SELECT",
		["S"] = "SELECT",
		["\19"] = "SELECT",
		["i"] = "INSERT",
		["ic"] = "INSERT",
		["ix"] = "INSERT",
		["R"] = "REPLACE",
		["Rc"] = "REPLACE",
		["Rx"] = "REPLACE",
		["Rv"] = "VIRT REPLACE",
		["Rvc"] = "VIRT REPLACE",
		["Rvx"] = "VIRT REPLACE",
		["c"] = "COMMAND",
		["cv"] = "VIM EX",
		["ce"] = "EX",
		["r"] = "PROMPT",
		["rm"] = "MORE",
		["r?"] = "CONFIRM",
		["!"] = "SHELL",
		["t"] = "TERMINAL",
	}

	-- Get the respective string to display.
	local mode = mode_to_str[vim.api.nvim_get_mode().mode] or "UNKNOWN"

	-- Set the highlight group.
	local hl = "Other"
	if mode:find("NORMAL") then
		hl = "Normal"
	elseif mode:find("PENDING") then
		hl = "Pending"
	elseif mode:find("VISUAL") then
		hl = "Visual"
	elseif mode:find("INSERT") or mode:find("SELECT") then
		hl = "Insert"
	elseif
		mode:find("COMMAND")
		or mode:find("TERMINAL")
		or mode:find("EX")
		or mode:find("SHELL")
		or mode:find("PROMPT")
		or mode:find("MORE")
		or mode:find("CONFIRM")
	then
		hl = "Command"
	end

	-- Show the mode with colored background (only on the text)
	return table.concat({
		string.format("%%#StatuslineMode%s# %s %%#StatusLine#", hl, mode),
	})
end

--- Git status (if any).
---@return string
function M.git_component()
	local head = vim.b.gitsigns_head
	if not head or head == "" then
		return ""
	end

	local component = string.format(" %s", head)

	local num_hunks = #(require("gitsigns").get_hunks() or {})
	if num_hunks > 0 then
		component = component .. string.format(" (#Hunks: %d)", num_hunks)
	end

	return component
end

--- Relative path of the current file.
---@return string
function M.filepath_component()
	local buf_name = vim.api.nvim_buf_get_name(0)
	if buf_name == "" then
		return ""
	end

	local cwd = vim.fn.getcwd()
	local relative_path = vim.fn.fnamemodify(buf_name, ":~:.")

	-- If the file is outside the cwd, try to get a relative path from cwd
	if not vim.startswith(buf_name, cwd) then
		relative_path = vim.fn.fnamemodify(buf_name, ":~")
	end

	return string.format("%%#StatuslineItalic#%s", relative_path)
end

---@type table<string, string?>
local progress_status = {
	client = nil,
	kind = nil,
	title = nil,
}

vim.api.nvim_create_autocmd("LspProgress", {
	group = vim.api.nvim_create_augroup("mariasolos/statusline", { clear = true }),
	desc = "Update LSP progress in statusline",
	pattern = { "begin", "end" },
	callback = function(args)
		-- This should in theory never happen, but I've seen weird errors.
		if not args.data then
			return
		end

		progress_status = {
			client = vim.lsp.get_client_by_id(args.data.client_id).name,
			kind = args.data.params.value.kind,
			title = args.data.params.value.title,
		}

		if progress_status.kind == "end" then
			progress_status.title = nil
			-- Wait a bit before clearing the status.
			vim.defer_fn(function()
				vim.cmd.redrawstatus()
			end, 3000)
		else
			vim.cmd.redrawstatus()
		end
	end,
})
--- The latest LSP progress message.
---@return string
function M.lsp_progress_component()
	if not progress_status.client or not progress_status.title then
		return ""
	end

	-- Avoid noisy messages while typing.
	if vim.startswith(vim.api.nvim_get_mode().mode, "i") then
		return ""
	end

	return table.concat({
		"%#StatuslineSpinner#󱥸 ",
		string.format("%%#StatuslineTitle#%s  ", progress_status.client),
		string.format("%%#StatuslineItalic#%s...", progress_status.title),
	})
end

--- The buffer's filetype.
---@return string
function M.filetype_component()
	local devicons = require("nvim-web-devicons")

	-- Special icons for some filetypes.
	local special_icons = {
		DiffviewFileHistory = { icons.misc.git, "Number" },
		DiffviewFiles = { icons.misc.git, "Number" },
		["ccc-ui"] = { icons.misc.palette, "Comment" },
		["dap-view"] = { icons.misc.bug, "Special" },
		["grug-far"] = { icons.misc.search, "Constant" },
		codecompanion = { icons.misc.robot, "Conditional" },
		fzf = { icons.misc.terminal, "Special" },
		gitcommit = { icons.misc.git, "Number" },
		gitrebase = { icons.misc.git, "Number" },
		lazy = { icons.symbol_kinds.Method, "Special" },
		lazyterm = { icons.misc.terminal, "Special" },
		minifiles = { icons.symbol_kinds.Folder, "Directory" },
		qf = { icons.misc.search, "Conditional" },
	}

	local filetype = vim.bo.filetype
	if filetype == "" then
		filetype = "[No Name]"
	end

	local icon, icon_hl
	if special_icons[filetype] then
		icon, icon_hl = unpack(special_icons[filetype])
	else
		local buf_name = vim.api.nvim_buf_get_name(0)
		local name, ext = vim.fn.fnamemodify(buf_name, ":t"), vim.fn.fnamemodify(buf_name, ":e")

		icon, icon_hl = devicons.get_icon(name, ext)
		if not icon then
			icon, icon_hl = devicons.get_icon_by_filetype(filetype, { default = true })
		end
	end
	icon_hl = M.get_or_create_hl(icon_hl)

	return string.format("%%#%s#%s %%#StatuslineTitle#%s", icon_hl, icon, filetype)
end

--- File-content encoding for the current buffer.
---@return string
function M.encoding_component()
	local encoding = vim.opt.fileencoding:get()
	return encoding ~= "" and string.format("%%#StatuslineModeSeparatorOther# %s", encoding) or ""
end

--- Diagnostic counts for the current buffer.
---@return string
function M.diagnostic_component()
	local diagnostics = vim.diagnostic.get(0)
	if #diagnostics == 0 then
		return ""
	end

	local counts = {
		[vim.diagnostic.severity.ERROR] = 0,
		[vim.diagnostic.severity.WARN] = 0,
		[vim.diagnostic.severity.INFO] = 0,
		[vim.diagnostic.severity.HINT] = 0,
	}

	for _, diagnostic in ipairs(diagnostics) do
		counts[diagnostic.severity] = counts[diagnostic.severity] + 1
	end

	local parts = {}
	if counts[vim.diagnostic.severity.ERROR] > 0 then
		table.insert(
			parts,
			string.format(
				"%%#%s#%s %d",
				M.get_or_create_hl("DiagnosticError"),
				icons.diagnostics.ERROR,
				counts[vim.diagnostic.severity.ERROR]
			)
		)
	end
	if counts[vim.diagnostic.severity.WARN] > 0 then
		table.insert(
			parts,
			string.format(
				"%%#%s#%s %d",
				M.get_or_create_hl("DiagnosticWarn"),
				icons.diagnostics.WARN,
				counts[vim.diagnostic.severity.WARN]
			)
		)
	end
	if counts[vim.diagnostic.severity.INFO] > 0 then
		table.insert(
			parts,
			string.format(
				"%%#%s#%s %d",
				M.get_or_create_hl("DiagnosticInfo"),
				icons.diagnostics.INFO,
				counts[vim.diagnostic.severity.INFO]
			)
		)
	end
	if counts[vim.diagnostic.severity.HINT] > 0 then
		table.insert(
			parts,
			string.format(
				"%%#%s#%s %d",
				M.get_or_create_hl("DiagnosticHint"),
				icons.diagnostics.HINT,
				counts[vim.diagnostic.severity.HINT]
			)
		)
	end

	return #parts > 0 and table.concat(parts, " ") or ""
end

--- The current line, total line count, and column position.
---@return string
function M.position_component()
	local line = vim.fn.line(".")
	local line_count = vim.api.nvim_buf_line_count(0)
	local col = vim.fn.virtcol(".")

	return table.concat({
		"%#StatuslineItalic#l: ",
		string.format("%%#StatuslineTitle#%d", line),
		string.format("%%#StatuslineItalic#/%d c: %d", line_count, col),
	})
end

--- Check if snacks picker is open
---@return boolean
local function is_snacks_picker_open()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) then
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.api.nvim_buf_is_valid(buf) then
				local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
				if filetype == "snacks_layout_box" then
					return true
				end
			end
		end
	end
	return false
end

--- Renders the statusline.
---@return string
function M.render()
	---@param components string[]
	---@return string
	local function concat_components(components)
		return vim.iter(components):skip(1):fold(components[1], function(acc, component)
			return #component > 0 and string.format("%s    %s", acc, component) or acc
		end)
	end

	-- Add offset when snacks picker is open
	local offset = ""
	if is_snacks_picker_open() then
		local sidebar_width = vim.g.sidebar_width or 30
		-- Create spacing to offset by sidebar width (approximate, using spaces)
		-- Each character is roughly 1 column, so we add spaces equal to sidebar width
		offset = string.rep(" ", sidebar_width)
	end

	return table.concat({
		"",
		offset,
		concat_components({
			M.mode_component(),
			M.filepath_component(),
		}),
		"%#StatusLine#%=",
		concat_components({
			M.git_component(),
			M.diagnostic_component(),
			M.filetype_component(),
			M.encoding_component(),
			M.position_component(),
		}),
		" ",
	})
end
vim.o.statusline = "%!v:lua.require'statusline'.render()"

return M
