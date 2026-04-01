#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles-v2}"

log() {
  printf '\n==> %s\n' "$1"
}

warn() {
  printf 'WARNING: %s\n' "$1"
}

have() {
  command -v "$1" >/dev/null 2>&1
}

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *)
      echo "unknown"
      ;;
  esac
}

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    log "Backing up $target -> $backup"
    mv "$target" "$backup"
  fi
}

link_file() {
  local source_file="$1"
  local target_file="$2"

  backup_if_exists "$target_file"
  log "Linking $target_file -> $source_file"
  ln -sfn "$source_file" "$target_file"
}

install_vim_plug() {
  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    log "Installing vim-plug"
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    log "vim-plug already installed"
  fi
}

install_vim_plugins() {
  if have vim; then
    log "Installing Vim plugins"
    vim +PlugInstall +qall || warn "Vim plugin install failed; run 'vim +PlugInstall +qall' manually"
  else
    warn "vim not found; skipping plugin installation"
  fi
}

install_homebrew_if_needed() {
  if have brew; then
    return
  fi

  log "Homebrew not found"
  warn "Install Homebrew first, then rerun bootstrap for package installation"
}

install_macos_packages() {
  if ! have brew; then
    install_homebrew_if_needed
    return
  fi

  log "Installing macOS packages with Homebrew"
  brew update
  brew install vim tmux wget yt-dlp grep || true
}

install_linux_packages() {
  if have apt-get; then
    log "Installing Linux packages with apt"
    sudo apt-get update
    sudo apt-get install -y vim tmux tree wget curl yt-dlp
  else
    warn "No supported Linux package manager detected; install packages manually"
  fi
}

main() {
  local os
  os="$(detect_os)"

  if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory not found: $DOTFILES_DIR"
    exit 1
  fi

  log "Using dotfiles directory: $DOTFILES_DIR"
  log "Detected OS: $os"

  case "$os" in
    macos)
      install_macos_packages
      ;;
    linux)
      install_linux_packages
      ;;
    *)
      warn "Unknown OS; skipping package installation"
      ;;
  esac

  log "Creating symlinks"
  if [ "$os" = "macos" ]; then
    link_file "$DOTFILES_DIR/shell/zsh/zshrc" "$HOME/.zshrc"
  fi

  link_file "$DOTFILES_DIR/shell/bash/bashrc" "$HOME/.bashrc"
  link_file "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
  link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

  install_vim_plug
  install_vim_plugins

  log "Bootstrap complete"
  echo "Open a new shell or run:"
  if [ "$os" = "macos" ]; then
    echo "  source ~/.zshrc"
  else
    echo "  source ~/.bashrc"
  fi
}

main "$@"
