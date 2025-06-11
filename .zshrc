# Path to your oh-my-zsh installation.
export ZSH="/Users/danielkjellid/.oh-my-zsh"

export PATH="/opt/homebrew/bin:$PATH"

ZSH_THEME="avit"

plugins=(zsh-syntax-highlighting zsh-autosuggestions history kube-ps1 zsh-fzf-history-search)

source $ZSH/oh-my-zsh.sh

# User configuration
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Klipy
#alias klipy="/Users/danielkjellid/Code/klipy/.venv/bin/python -m klipy"
export PATH="/Users/danielkjellid/.klipy/bin:$PATH"

# Kube ps-1
PROMPT=$PROMPT'$(kube_ps1) '
KUBE_PS1_PREFIX="["
KUBE_PS1_SUFFIX="]"
KUBE_PS1_ENABLED=true 

export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export PATH="/Users/danielkjellid/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

eval "$(pyenv init -)"
eval "$(direnv hook zsh)"
eval $(thefuck --alias)
eval "$(starship init zsh)"

# Aliases
alias k="kubectl"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias pym="poetry run python manage.py"
alias um="uv run python manage.py"
alias pr="poetry run"
alias ur="uv run"
alias config='/usr/bin/git --git-dir=/Users/danielkjellid/.cfg/ --work-tree=/Users/danielkjellid'

# Custom commands
tienda-start() { mprocs -c "$1.yaml" }

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
