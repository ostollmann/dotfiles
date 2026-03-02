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

# fzf — --zsh flag requires 0.48.0+; fall back to system scripts on older versions
if command -v fzf &>/dev/null; then
  _fzf_minor=$(fzf --version | cut -d' ' -f1 | cut -d. -f2)
  if [[ $_fzf_minor -ge 48 ]]; then
    source <(fzf --zsh)
  else
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ]   && source /usr/share/doc/fzf/examples/completion.zsh
  fi
  unset _fzf_minor
fi

# Node memory
export NODE_OPTIONS="--max-old-space-size=8192"

# Local bin
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Bin"

# Machine-specific config (secrets, local paths — not committed)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
