local status_ok, pckg = pcall(require, "venv-lsp")

if not status_ok then
  vim.notify("Unable to require venv-lsp, skipping")
  return
end

return pckg.setup()
