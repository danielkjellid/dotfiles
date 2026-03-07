# Path to your oh-my-zsh installation.
export ZSH="$ZDOTDIR/.oh-my-zsh"

ZSH_THEME="avit"

plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    history
    kube-ps1
    zsh-fzf-history-search
    fzf
    #zsh-autocomplete) - disable for now, has a memory leak, so it hogs 100% of cpu
)

source $ZSH/oh-my-zsh.sh

# User configuration
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Kube ps-1
PROMPT=$PROMPT'$(kube_ps1) '
KUBE_PS1_PREFIX="["
KUBE_PS1_SUFFIX="]"
KUBE_PS1_ENABLED=true

eval "$(pyenv init -)"
eval "$(direnv hook zsh)"
eval "$(thefuck --alias)"
eval "$(starship init zsh)"

# Aliases
alias k="kubectl"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias um="uv run python manage.py"
alias ur="uv run"
alias vim="nvim"

# Custom commands
tienda-start() { mprocs -c "$1.yaml" }

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
