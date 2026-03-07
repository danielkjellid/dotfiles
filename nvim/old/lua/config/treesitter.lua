local status_ok, configs = pcall(require, "nvim-treesitter.configs")

if not status_ok then
  vim.notify("Unable to require treesitter, syntax highlighting disabled")
  return
end

configs.setup {
  ensure_installed = "all",
  sync_install = false,
  ignore_install = { "ipkg" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,

  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
   enable = true,
    enabled_autocmd = false
  }
}

require("nvim-treesitter.install").prefer_git = true
