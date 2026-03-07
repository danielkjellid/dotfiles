export CONFIG_HOME="$HOME/.config"

# Paths
export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/Users/danielkjellid/.klipy/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

export ZDOTDIR="$CONFIG_HOME/zsh"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Path to starship config. Can't be wrapped in quotes.
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Set up neovim as the default editor.
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
