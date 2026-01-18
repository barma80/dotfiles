# Dotfiles

Personal dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── stow/
│   ├── zsh/          # Zsh configuration
│   │   ├── .zshrc
│   │   ├── .zimrc
│   │   ├── .p10k.zsh
│   │   └── .zshrc.local
│   ├── tmux/         # Tmux configuration
│   │   └── .tmux.conf
│   ├── nvim/         # Neovim configuration
│   │   └── .config/nvim/init.lua
│   ├── shell/        # Shell configs (bash, profile)
│   │   ├── .profile
│   │   └── .bashrc
│   ├── git/          # Git configuration
│   │   └── .gitconfig
│   └── editors/      # Editor configurations
│       └── .config/
│           ├── zed/settings.json
│           └── Cursor/User/settings.json
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
bash stow.sh link

# Link specific packages
bash stow.sh link zsh tmux

# Unlink packages
bash stow.sh unlink nvim

# Relink after editing (restow)
bash stow.sh relink zsh

# Check status
bash stow.sh status

# List available packages
bash stow.sh list
```

## Packages

| Package | Files | Description |
|---------|-------|-------------|
| zsh | `.zshrc`, `.zimrc`, `.p10k.zsh`, `.zshrc.local` | Zsh with Zim framework and Powerlevel10k |
| tmux | `.tmux.conf` | Minimalist tmux configuration |
| nvim | `.config/nvim/init.lua` | Neovim with lazy.nvim |
| shell | `.profile`, `.bashrc` | Shell profile and bash configuration |
| git | `.gitconfig` | Git configuration |
| editors | `.config/zed/settings.json`, `.config/Cursor/User/settings.json` | Editor settings |

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

### Editors
- Zed: zsh terminal, rust-analyzer, basedpyright
- Cursor: zsh terminal integration
