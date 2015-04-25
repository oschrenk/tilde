# tilde

**THIS is BETA software and under development. The author takes no responsibility in screwing up your system.**

tilde is a fish shell only replacement for [node-deja](https://github.com/mcantelon/node-deja).

## Usage

`tilde <COMMAND> [OPTIONS]`

Implemented commands:

- `link <REPO NAME>`
- `clone <GITHUB REPO NAME>`

### `ls [REPO NAME][/SUBDIRECTORY]`

View items in (a subdirectory) of a repository. For example `tilde ls dotfiles` might output:

```
.DS_Store [conflicts]
.tildeignore
.vim [dir]
.vimrc
README.md [unlinked]
```

Besides the normal files, there might be additional information

- `[dir]`, if the entry is a directory
- `[unlinked]`, if the entry doesn't exist in `$HOME`
- `[conflicts]`, if there is an entry in `$HOME` with the same name

## Install

```
wget --directory-prefix=$HOME/.config/fish/functions/ https://raw.githubusercontent.com/oschrenk/tilde/master/tilde.fish
```

