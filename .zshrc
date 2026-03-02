export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="lambda"

plugins=(git vscode poetry)

source $ZSH/oh-my-zsh.sh

# Editor
export EDITOR='vim'

# Keybindings
bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# NVM — check Homebrew (macOS) first, then fall back to ~/.nvm (Linux/manual install)
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# pyenv
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init --path)"
fi

# fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# Node memory
export NODE_OPTIONS="--max-old-space-size=8192"

# Local bin
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Bin"

# Machine-specific config (secrets, local paths — not committed)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
