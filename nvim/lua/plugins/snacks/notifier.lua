local icons = require('icons')

local M = {
  config = {
    timeout = 6000, -- In milliseconds,
    icons = {
      error = icons.diagnostics.ERROR,
      warn = icons.diagnostics.WARN,
      info = icons.diagnostics.INFO,
    },
    style = "compact",
    top_down = false,
  }
}

return M