local status_ok, pckg = pcall(require, "rainbow-delimiters.setup")

if not status_ok then
  vim.notify("Unable to require rainbow-delimiters, syntax highligthing of delimiters will be disabled")
  return
end


local opts = {}

return pckg.setup(opts)
