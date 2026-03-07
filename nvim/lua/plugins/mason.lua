-- Mason is a package manager for Neovim.
-- https://github.com/mason-org/mason.nvim
return {
  "mason-org/mason-lspconfig.nvim",
  event = "VeryLazy",
  opts = {
    ensure_installed = {
      "rust_analyzer",
      -- "pyrefly",
      "basedpyright",
      "ts_ls",
      "lua_ls",
      "cssls",
      "html",
      "terraformls",
      "ruff",
    },
  },
  dependencies = {
    { 
      "mason-org/mason.nvim", 
      opts = {} -- This needs to be empty so that mason is properly initialized.
    },
    "neovim/nvim-lspconfig",
  },
}