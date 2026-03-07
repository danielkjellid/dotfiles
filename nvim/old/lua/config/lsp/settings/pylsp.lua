description = [[
https://github.com/python-lsp/python-lsp-server

A Python 3.6+ implementation of the Language Server Protocol.

See the [project's README](https://github.com/python-lsp/python-lsp-server) for installation instructions.

Configuration options are documented [here](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md).
In order to configure an option, it must be translated to a nested Lua table.
]]

return {
  settings = {
    pylsp = {
      plugins = {
        flake8 = {
          enabled = false -- I use ruff instead of flake8
        }
      }
    }
  }
}
