# Dotfiles

Personal dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── stow/
│   ├── zsh/          # Zsh configuration
│   │   ├── .zshrc
│   │   ├── .zimrc
│   │   └── .p10k.zsh
│   ├── tmux/         # Tmux configuration
│   │   └── .tmux.conf
│   └── nvim/         # Neovim configuration
│       └── .config/nvim/init.lua
├── stow.sh           # Stow manager script
└── README.md
```

## Prerequisites

```bash
sudo apt install stow
```

## Usage

```bash
cd ~/dotfiles

# Link all packages
./stow.sh link

# Link specific packages
./stow.sh link zsh tmux

# Unlink packages
./stow.sh unlink nvim

# Relink after editing (restow)
./stow.sh relink zsh

# Check status
./stow.sh status

# List available packages
./stow.sh list
```

## Packages

| Package | Files | Description |
|---------|-------|-------------|
| zsh | `.zshrc`, `.zimrc`, `.p10k.zsh` | Zsh with Zim framework and Powerlevel10k |
| tmux | `.tmux.conf` | Minimalist tmux configuration |
| nvim | `.config/nvim/init.lua` | Neovim with lazy.nvim |

## Features

### Zsh
- Zim framework for fast loading
- Powerlevel10k prompt
- Syntax highlighting
- Auto-suggestions
- History substring search
- Amazon Q integration
- Smart aliases (suffix, global)
- Auto-activate virtualenvs

### Tmux
- Prefix: `Ctrl+a`
- Vim-style navigation
- Mouse support
- Nord-inspired colors
- Status bar at top

### Neovim
- Lazy.nvim plugin manager
- LSP support
- Treesitter syntax highlighting
- Telescope fuzzy finder
- Tokyo Night theme
