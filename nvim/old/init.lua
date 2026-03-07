if vim.g.vscode then
  require "config.keymaps" 
else
  require "config.options"
  require "config.keymaps"
  require "config.plugins"
  require "config.colorscheme"
  require "config.comment"
  require "config.cmp"
  require "config.lsp"
  require "config.venv-lsp"
  require "config.rainbow-delimiters"
  require "config.tree"
  require "config.treesitter"
end

