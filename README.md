# dotfiles-v2

Cross-platform dotfiles for macOS, Linux, and WSL.

## Goals

- Keep one repo for shell/editor/tmux configuration
- Share common behavior across machines
- Separate OS-specific behavior cleanly
- Use symlinks from `$HOME` into this repo
- Keep the setup minimal and maintainable

## Structure

```text
shell/
  common/
    aliases
    exports
    functions
  bash/
    bashrc
  zsh/
    zshrc
  linux/
    aliases
    exports
    functions
  macos/
    aliases
    exports
    functions

vim/
  vimrc

tmux/
  tmux.conf

setup/
  bootstrap.sh
  test-bash.sh
  run-test-bash.sh
```
## Portability model

There are three layers:

1. `shell/common/`

   * portable aliases, exports, and functions
   * should work everywhere

2. `shell/linux/` and `shell/macos/`

   * OS-specific overrides and additions
   * examples: `apt`, GNU `ls`, macOS `ls -G`, `CLICOLOR`

3. `shell/bash/bashrc` and `shell/zsh/zshrc`

   * thin shell entry points
   * set shell-specific options
   * source common and OS-specific layers

## Conventions

* Repo lives at: `~/.dotfiles-v2`
* Live dotfiles in `$HOME` are symlinks into this repo
* `bash` is the lowest common denominator
* `zsh` is used on macOS
* `vim` is used as the terminal editor
* `tmux` uses `Ctrl-a` as prefix

## Bootstrap a new machine

Clone the repo:

```bash
git clone <repo-url> ~/.dotfiles-v2
```

Run bootstrap:

```bash
~/.dotfiles-v2/setup/bootstrap.sh
```

The bootstrap script will:

* detect macOS vs Linux
* install basic packages where supported
* create symlinks for shell, Vim, and tmux config
* install vim-plug if missing
* install Vim plugins

## Manual links

If needed, you can link files manually.

### Linux / WSL

```bash
ln -sf ~/.dotfiles-v2/shell/bash/bashrc ~/.bashrc
ln -sf ~/.dotfiles-v2/vim/vimrc ~/.vimrc
ln -sf ~/.dotfiles-v2/tmux/tmux.conf ~/.tmux.conf
```

### macOS

```bash
ln -sf ~/.dotfiles-v2/shell/zsh/zshrc ~/.zshrc
ln -sf ~/.dotfiles-v2/vim/vimrc ~/.vimrc
ln -sf ~/.dotfiles-v2/tmux/tmux.conf ~/.tmux.conf
```

## Vim setup

Vim plugins are managed with `vim-plug`.

Install plugins manually:

```bash
vim +PlugInstall +qall
```

## Notes

* `common` should only contain portable behavior
* anything OS-specific should move into `linux` or `macos`
* if an alias or function is rarely used, remove it
* keep entry-point files thin

## Future cleanup

* prune unused aliases after a few weeks of use
* extend Linux package installation if non-apt systems matter
* optionally add shell/tool verification checks

````
