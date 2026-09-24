#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlink() {
  local src="$DOTFILES_DIR/$1"
  local dst="$HOME/$1"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  $dst → $src"
}

echo "==> Symlinking dotfiles"
symlink .gitconfig
symlink .tmux.conf
symlink .config/herdr/config.toml
symlink .zshrc
symlink .prompt.zsh
symlink .config/git/ignore

echo "==> Installing oh-my-zsh (if not present)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "  oh-my-zsh already installed"
fi

echo "==> Installing fzf from source (system apt version too old for --zsh)"
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi
"$HOME/.fzf/install" --bin

echo "==> Installing tmux plugin manager (if not present)"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  echo "  tpm already installed"
fi

echo "==> Installing tmux plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo ""
echo "Done. Start a new shell or run: source ~/.zshrc"
