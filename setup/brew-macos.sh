#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed."
  exit 1
fi

brew update

brew install \
  vim \
  tmux \
  tree \
  wget \
  yt-dlp \
  grep \
  coreutils
