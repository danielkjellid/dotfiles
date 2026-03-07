local colorscheme = "catppuccin"

local status_ok, _scheme = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found! Falling back to default")
  return
end
