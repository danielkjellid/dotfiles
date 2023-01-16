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
alias klipy="/Users/danielkjellid/Code/klipy/.venv/bin/python -m klipy"
export PATH="/Users/danielkjellid/.klipy/bin:$PATH"

# Kube ps-1
PROMPT=$PROMPT'$(kube_ps1) '
KUBE_PS1_PREFIX="["
KUBE_PS1_SUFFIX="]"
KUBE_PS1_ENABLED=true 

export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="/Users/danielkjellid/.local/bin:$PATH"

eval "$(pyenv init -)"
eval "$(direnv hook zsh)"
eval $(thefuck --alias)
eval "$(starship init zsh)"

# Aliases
alias k="kubectl"
alias mat='echo "\e[0;31mNY28:\033[0m" && curl -s https://portal.ny28.no/wp-content/uploads/meny28.pdf | pdftotext - - && echo "\e[0;31mNY24:\033[0m" && curl -s https://www.ny24.no/api/fetch/$(date "+%u") | jq'
alias pym='poetry run python manage.py'
alias pr='poetry run'
alias config='/usr/bin/git --git-dir=/Users/danielkjellid/.cfg/ --work-tree=/Users/danielkjellid'
