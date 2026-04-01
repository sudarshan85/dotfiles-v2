#!/usr/bin/env bash

# source the new dotfiles bash config in the current shell
source "$HOME/dotfiles-v2/shell/common/exports"
source "$HOME/dotfiles-v2/shell/common/aliases"
source "$HOME/dotfiles-v2/shell/common/functions"

source "$HOME/dotfiles-v2/shell/linux/exports"
source "$HOME/dotfiles-v2/shell/linux/aliases"
source "$HOME/dotfiles-v2/shell/linux/functions"

echo "Loaded dotfiles-v2 test config"
echo "EDITOR=$EDITOR"
alias gs 2>/dev/null
type act 2>/dev/null
type mkcd 2>/dev/null
