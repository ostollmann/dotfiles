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

# Local bin — fzf prepended so it shadows the system apt version (too old for --zsh)
export PATH="$HOME/.fzf/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Bin"
export PATH="$PATH:$HOME/Repos/apx-devboxes/bin"
export COLORTERM=truecolor

if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
    mkdir -p "$HOME/.ssh"
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"

    if [ -n "$TMUX" ]; then
      tmux set-environment -g SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
    fi
fi



# Prompt — single-line, host-color-coded. Loaded last so it overrides OMZ theme.
[ -f "$HOME/.prompt.zsh" ] && source "$HOME/.prompt.zsh"

# Machine-specific config
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

