local diagnostic_icons = require("icons").diagnostics

-- Diagnostic configuration.
vim.diagnostic.config({
	status = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
			[vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
			[vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
			[vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
		},
	},
	virtual_text = {
		prefix = "",
		spacing = 2,
		format = function(diagnostic)
			-- Expand errors and warnings (show full message), keep info compressed
			local severity = diagnostic.severity
			if severity == vim.diagnostic.severity.ERROR or severity == vim.diagnostic.severity.WARN then
				-- Show full message for errors and warnings
				local icon = diagnostic_icons[vim.diagnostic.severity[severity]]
				return string.format("%s %s", icon, diagnostic.message)
			else
				-- Compressed format for info and hints
				local special_sources = {
					["Lua Diagnostics."] = "lua",
					["Lua Syntax Check."] = "lua",
				}

				local message = diagnostic_icons[vim.diagnostic.severity[severity]]
				if diagnostic.source then
					message = string.format("%s %s", message, special_sources[diagnostic.source] or diagnostic.source)
				end
				if diagnostic.code then
					message = string.format("%s[%s]", message, diagnostic.code)
				end

				return message .. " "
			end
		end,
	},
	float = {
		source = "if_many",
		-- Show severity icons as prefixes.
		prefix = function(diag)
			local level = vim.diagnostic.severity[diag.severity]
			local prefix = string.format(" %s ", diagnostic_icons[level])
			return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
		end,
	},
	-- Enable signs in the gutter.
	signs = true,
})

-- LSP server configurations (Neovim 0.11+ native API)
-- See :help vim.lsp.config

-- Disable semantic tokens globally - rely on treesitter for syntax highlighting
-- Override the semantic tokens start function to prevent tokens from being requested
if vim.lsp.semantic_tokens then
	-- Stop any existing semantic tokens
	for _, client in ipairs(vim.lsp.get_clients()) do
		if client.server_capabilities.semanticTokensProvider then
			vim.lsp.semantic_tokens.stop(client.id, 0)
		end
	end

	-- Override start function to prevent new semantic tokens from starting
	local original_start = vim.lsp.semantic_tokens.start
	vim.lsp.semantic_tokens.start = function(...)
		-- Do nothing - prevent semantic tokens from starting
		return
	end
end

-- Also disable semantic tokens when clients attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("DisableSemanticTokens", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.semanticTokensProvider then
			-- Stop semantic tokens if they were started
			if vim.lsp.semantic_tokens then
				vim.lsp.semantic_tokens.stop(client.id, args.buf)
			end
		end
	end,
})

--- Find a .venv directory in the project root and return venv info
---@param root_dir string
---@return { python: string, site_packages: string }|nil
local function get_venv_info(root_dir)
	local venv_path = root_dir .. "/.venv"
	local python_path = venv_path .. "/bin/python"

	if vim.fn.executable(python_path) ~= 1 then
		return nil
	end

	-- Find site-packages directory (handles different Python versions)
	local lib_path = venv_path .. "/lib"
	local handle = vim.uv.fs_scandir(lib_path)
	if not handle then
		return nil
	end

	while true do
		local name, type = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end
		if type == "directory" and name:match("^python%d") then
			local site_packages = lib_path .. "/" .. name .. "/site-packages"
			if vim.fn.isdirectory(site_packages) == 1 then
				return {
					python = python_path,
					site_packages = site_packages,
				}
			end
		end
	end

	return { python = python_path, site_packages = nil }
end

vim.lsp.config.basedpyright = {
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".venv", ".git" },
	on_init = function(client)
		-- Auto-detect venv and configure paths
		local root = client.root_dir
		if not root then
			return
		end

		local venv = get_venv_info(root)
		if not venv then
			return
		end

		local settings = {
			python = {
				pythonPath = venv.python,
				venvPath = root,
				venv = ".venv",
			},
		}

		client.settings = vim.tbl_deep_extend("force", client.settings or {}, settings)
	end,
	settings = {
		basedpyright = {
			analysis = {
				-- Use ruff for linting, so disable type checking diagnostics
				-- to avoid duplicates.
				typeCheckingMode = "off",
				-- Enable go-to-definition for external packages
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				-- Include all files in the workspace for analysis (helps with imports)
				diagnosticMode = "openFilesOnly",
			},
		},
	},
}

vim.lsp.config.ruff = {
	settings = {
		logLevel = "debug",
	},
}

vim.lsp.config.ts_ls = {
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
}

vim.lsp.config.lua_ls = {}

-- Enable the LSP servers
vim.lsp.enable({ "basedpyright", "ruff", "ts_ls", "lua_ls" })
