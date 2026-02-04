# Terminal & Tools Cheat Sheet
## Pop!_OS Zsh Environment

---

## Table of Contents
1. [TUI Applications](#tui-applications)
2. [Zsh Keybindings](#zsh-keybindings)
3. [Aliases](#aliases)
4. [Custom Functions](#custom-functions)
5. [Named Directories](#named-directories)
6. [ZMV - Batch File Operations](#zmv---batch-file-operations)
7. [CHPWD Hooks](#chpwd-hooks-auto-actions)
8. [Zsh Options & Features](#zsh-options--features)
9. [Tool Integrations](#tool-integrations)
10. [Neovim Keybindings](#neovim-keybindings)
11. [Tmux Keybindings](#tmux-keybindings)
12. [Dotfiles Management](#dotfiles-management)

---

## TUI Applications

| App | Command | Description | Installation |
|-----|---------|-------------|--------------|
| **btop** | `btop` or `top` | System monitor (CPU, RAM, disk, network) | apt |
| **lazygit** | `lg` or `lazygit` | Git TUI client | binary |
| **yazi** | `y` or `yazi` | File manager with previews | cargo |
| **ncdu** | `ncdu` | Disk usage analyzer | apt |
| **fzf** | `fzf`, `Ctrl+R`, `Ctrl+T` | Fuzzy finder | apt |
| **bat** | `bat` or `cat` (aliased) | Better cat with syntax highlighting | cargo |
| **eza** | `ls`, `ll`, `la`, `lt` (aliased) | Modern ls with icons | cargo |
| **lsd** | fallback if eza missing | Colorful ls with icons | apt |
| **zoxide** | `z <dir>`, `zi` | Smart cd that learns your habits | cargo |
| **neovim** | `nvim`, `vim`, `vi` | Text editor with LSP support | apt |
| **tmux** | `tmux` | Terminal multiplexer | apt |
| **atuin** | `Ctrl+R` (overrides fzf) | Shell history search with sync | binary |

### App Quick Reference

```bash
# btop - System Monitor
btop                    # Launch btop
# Inside btop: q=quit, h=help, f=filter, s=search

# lazygit - Git TUI
lg                      # Launch lazygit
# Inside: space=stage, c=commit, P=push, p=pull, q=quit

# yazi - File Manager
y                       # Launch yazi
# Inside: hjkl=navigate, l/Enter=open, h=parent, q=quit
#         y=yank, d=delete, p=paste, r=rename, .=hidden

# ncdu - Disk Usage
ncdu                    # Analyze current directory
ncdu /                  # Analyze root (with sudo)
# Inside: d=delete, n=sort by name, s=sort by size, q=quit

# fzf - Fuzzy Finder
fzf                     # Interactive file finder
Ctrl+R                  # History search
Ctrl+T                  # File search (insert path)
Alt+C                   # cd to directory (fzf)
```

---

## Zsh Keybindings

### Navigation & Editing

| Keybinding | Action |
|------------|--------|
| `Ctrl+A` | Beginning of line |
| `Ctrl+E` | End of line |
| `Ctrl+U` | Delete from cursor to start of line |
| `Ctrl+K` | Delete from cursor to end of line |
| `Ctrl+W` | Delete word before cursor |
| `Ctrl+H` / `Ctrl+Backspace` | Delete word before cursor |
| `Ctrl+Right` | Forward one word |
| `Ctrl+Left` | Backward one word |
| `Ctrl+Delete` | Delete word after cursor |
| `Alt+T` | Swap/transpose words |

### History & Search

| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Reverse history search (fzf/atuin) |
| `Up/Down` | History substring search (type first, then arrow) |
| `Ctrl+P` | Previous history (substring match) |
| `Ctrl+N` | Next history (substring match) |
| `Space` | **Magic space** - expand `!!`, `!$`, `!*` inline |

### Special Actions

| Keybinding | Action |
|------------|--------|
| `Ctrl+X Ctrl+E` | Edit current command in `$EDITOR` (nvim) |
| `Ctrl+X Ctrl+C` | Copy current line to clipboard |
| `Ctrl+X Ctrl+L` | Clear screen but preserve current buffer |
| `Ctrl+_` | Undo last edit |
| `Ctrl+Q` | Amazon Q chat (if logged in) |
| `Alt+S` | Insert `sudo ` at beginning of line |
| `Tab Tab` | Show completion menu |

### Magic Space Examples

```bash
sudo !!<space>          # Expands to: sudo <last command>
echo !$<space>          # Expands to: echo <last argument>
vim !*<space>           # Expands to: vim <all args from last cmd>
!git<space>             # Expands to last command starting with 'git'
```

---

## Aliases

### Navigation

| Alias | Expands To |
|-------|------------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `.....` | `cd ../../../..` |

### File Listing (eza/lsd)

| Alias | Description |
|-------|-------------|
| `ls` | List with icons, directories first |
| `ll` | Long list with git status |
| `la` | List all (including hidden) |
| `lt` | Tree view (2 levels) |
| `lta` | Tree view including hidden |

### Git

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gl` | `git log --oneline --graph -10` |
| `gla` | `git log --oneline --graph --all` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gb` | `git branch` |
| `gst` | `git stash` |
| `gstp` | `git stash pop` |

### TUI Apps

| Alias | Command |
|-------|---------|
| `lg` | `lazygit` |
| `y` | `yazi` |
| `top` | `btop` |
| `vim` / `vi` | `nvim` |
| `cat` | `bat --paging=never` |
| `catp` | `bat --plain` |

### Miscellaneous

| Alias | Description |
|-------|-------------|
| `c` | Clear screen |
| `h` | History |
| `j` | Jobs list |
| `path` | Print PATH (one per line) |
| `now` | Current date/time |
| `week` | Current week number |

### Suffix Aliases (Open by Extension)

Just type the filename to open it in the appropriate app:

```bash
./config.json           # Opens in nvim
./README.md             # Opens in nvim
./notes.txt             # Opens in nvim
./app.log               # Opens in less +F (follow mode)
./archive.tar.gz        # Auto-extracts
```

Supported extensions for editor: `txt`, `md`, `json`, `yaml`, `yml`, `toml`, `ini`, `cfg`, `conf`, `py`, `rb`, `pl`, `php`, `js`, `ts`, `jsx`, `tsx`, `vue`, `svelte`, `go`, `rs`, `c`, `cpp`, `h`, `hpp`, `html`, `htm`, `css`, `scss`, `sass`, `less`, `Makefile`

### Global Aliases (Use Anywhere in Command)

| Alias | Expands To | Example |
|-------|------------|---------|
| `NE` | `2>/dev/null` | `ls /root NE` |
| `NO` | `>/dev/null` | `echo test NO` |
| `NUL` | `>/dev/null 2>&1` | `command NUL` |
| `J` | `\| jq` | `curl api J` |
| `JC` | `\| jq -C` | `curl api JC` |
| `L` | `\| less` | `cat file L` |
| `LR` | `\| less -R` | `ls --color LR` |
| `G` | `\| grep` | `ps aux G python` |
| `GI` | `\| grep -i` | `ls GI readme` |
| `H` | `\| head` | `cat file H` |
| `T` | `\| tail` | `cat file T` |
| `TF` | `\| tail -f` | `cat log TF` |
| `S` | `\| sort` | `ls S` |
| `SU` | `\| sort -u` | `cat file SU` |
| `WC` | `\| wc -l` | `ls WC` |
| `C` | `\| wl-copy` | `pwd C` (copy to clipboard) |
| `P` | `$(wl-paste)` | `echo P` (paste from clipboard) |

---

## Custom Functions

### mkcd - Make and Enter Directory

```bash
mkcd newproject         # Creates 'newproject' and cd into it
mkcd path/to/deep/dir   # Creates full path and enters
```

### ff / fdir - Find Files/Directories

```bash
ff config               # Find files containing 'config'
fdir node               # Find directories containing 'node'
```

### extract - Universal Archive Extractor

```bash
extract archive.tar.gz
extract file.zip
extract package.7z
# Supports: tar.gz, tar.bz2, tar.xz, tar.zst, zip, rar, 7z, gz, bz2
```

### bak - Quick Backup

```bash
bak important.conf      # Creates important.conf.bak.20250118_143022
```

### top10 - Most Used Commands

```bash
top10                   # Shows your 10 most frequently used commands
```

---

## Named Directories

Access common directories with `~alias`:

| Shortcut | Path |
|----------|------|
| `~projects` | `~/projects` |
| `~config` | `~/.config` |
| `~downloads` | `~/Downloads` |
| `~documents` | `~/Documents` |
| `~desktop` | `~/Desktop` |

```bash
cd ~projects            # Go to ~/projects
ls ~config              # List ~/.config
cp file ~downloads      # Copy to ~/Downloads
```

---

## ZMV - Batch File Operations

ZMV allows powerful batch renaming using patterns.

### Basic Usage

```bash
# Rename: Replace pattern
zmv '*.txt' '*.md'              # *.txt -> *.md
zmv '*.JPG' '*.jpg'             # Lowercase extensions

# Copy with pattern
zcp '*.conf' '*.conf.bak'       # Backup all .conf files

# Link with pattern
zln 'src/*' 'dest/*'            # Symlink files

# Dry run (preview changes)
zmvn '*.txt' '*.md'             # Show what would happen
```

### Advanced Patterns

```bash
# Using capture groups (without -W flag)
noglob zmv '(*).txt' '$1.md'                    # file.txt -> file.md
noglob zmv '(*).(*)' '$1_backup.$2'             # file.txt -> file_backup.txt
noglob zmv 'IMG_(*).jpg' 'photo_$1.jpg'         # IMG_001.jpg -> photo_001.jpg

# Lowercase all filenames
noglob zmv '(*)' '${(L)1}'

# Add prefix to all files
noglob zmv '(*)' 'prefix_$1'
```

---

## CHPWD Hooks (Auto-Actions)

These run automatically when you change directories:

### Auto-Activate Python Virtualenv

```bash
cd myproject/           # If .venv/ or venv/ exists, auto-activates
cd ..                   # Leaving project auto-deactivates
```

### Auto-Load NVM Version

```bash
cd node-project/        # If .nvmrc exists, runs 'nvm use'
```

---

## Zsh Options & Features

### Enabled Options

| Option | Effect |
|--------|--------|
| `CORRECT` | Suggests corrections for mistyped commands |
| `CORRECT_ALL` | Suggests corrections for arguments too |
| `AUTO_CD` | Type directory name to cd (no `cd` needed) |
| `EXTENDED_GLOB` | Advanced glob patterns (`**`, `~`, `^`) |
| `SHARE_HISTORY` | Share history between all terminals |
| `HIST_IGNORE_SPACE` | Commands starting with space not saved |

### Extended Glob Examples

```bash
ls **/*.py              # All .py files recursively
ls *.txt~old*           # .txt files NOT matching 'old*'
ls ^*.log               # Everything except .log files
ls *(.)                 # Only regular files
ls *(/)                 # Only directories
ls *(@)                 # Only symlinks
ls *(m-7)               # Modified in last 7 days
ls *(Lk+100)            # Larger than 100KB
```

### Auto-CD

```bash
..                      # Same as: cd ..
projects                # Same as: cd projects (if exists)
/etc                    # Same as: cd /etc
```

---

## Tool Integrations

### Zoxide (Smart CD)

```bash
z projects              # Jump to most frecent 'projects' match
z doc                   # Jump to ~/Documents (learns from usage)
zi                      # Interactive selection with fzf
z -                     # Go to previous directory
```

### FZF (Fuzzy Finder)

```bash
# Standalone
fzf                     # Find files interactively
vim $(fzf)              # Open selected file in vim

# Keybindings
Ctrl+T                  # Insert file path at cursor
Ctrl+R                  # Search command history
Alt+C                   # cd into selected directory

# With other commands
kill -9 **<Tab>         # Fuzzy select process to kill
cd **<Tab>              # Fuzzy select directory
vim **<Tab>             # Fuzzy select file to edit
```

### Atuin (Enhanced History)

```bash
Ctrl+R                  # Search history (replaces fzf if installed)
# Features: Full-text search, sync across machines, statistics
```

### Amazon Q CLI

```bash
# Type-ahead suggestions appear as you type (after q login)
q chat                  # Start AI chat
q translate             # Natural language to shell command
Ctrl+Q                  # Quick launch Q chat
qa                      # Alias for q chat
qt                      # Alias for q translate
```

---

## Neovim Keybindings

Leader key: `Space`

### File Operations

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Save and quit |
| `<leader>e` | Toggle file explorer (Neo-tree) |

### Navigation

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Switch buffers |
| `<leader>fh` | Help tags |
| `Shift+H` | Previous buffer |
| `Shift+L` | Next buffer |

### Window Navigation (works with tmux)

| Key | Action |
|-----|--------|
| `Ctrl+H` | Move to left window/pane |
| `Ctrl+J` | Move to window below |
| `Ctrl+K` | Move to window above |
| `Ctrl+L` | Move to right window/pane |

### Editing

| Key | Action |
|-----|--------|
| `gc` | Toggle comment (visual mode) |
| `gcc` | Toggle comment (current line) |
| `<` / `>` | Indent in visual mode (stays selected) |
| `J` / `K` | Move lines up/down (visual mode) |

### Terminal

| Key | Action |
|-----|--------|
| `<leader>t` | Open terminal |
| `Esc Esc` | Exit terminal mode |
| `<leader>s` | Send selection to tmux pane |

---

## Tmux Keybindings

Prefix: `Ctrl+A`

### Session Management

| Key | Action |
|-----|--------|
| `prefix d` | Detach from session |
| `prefix s` | List sessions |
| `prefix $` | Rename session |

### Windows

| Key | Action |
|-----|--------|
| `prefix c` | New window |
| `prefix ,` | Rename window |
| `prefix n` | Next window |
| `prefix p` | Previous window |
| `prefix 0-9` | Switch to window number |
| `prefix &` | Kill window |

### Panes

| Key | Action |
|-----|--------|
| `prefix \|` | Split vertically |
| `prefix -` | Split horizontally |
| `prefix x` | Kill pane |
| `prefix z` | Toggle pane zoom |
| `prefix {` / `}` | Swap panes |
| `prefix Space` | Cycle layouts |

### Navigation (Vim-style)

| Key | Action |
|-----|--------|
| `prefix h` | Move to left pane |
| `prefix j` | Move to pane below |
| `prefix k` | Move to pane above |
| `prefix l` | Move to right pane |
| `Ctrl+H/J/K/L` | Seamless vim/tmux navigation |

### Copy Mode

| Key | Action |
|-----|--------|
| `prefix [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Yank selection (copies to clipboard) |
| `prefix ]` | Paste |

### Resize Panes

| Key | Action |
|-----|--------|
| `prefix H` | Resize left |
| `prefix J` | Resize down |
| `prefix K` | Resize up |
| `prefix L` | Resize right |

---

## Dotfiles Management

### Stow Commands

```bash
cd ~/dotfiles

# Link all packages
bash stow.sh link

# Link specific packages
bash stow.sh link zsh tmux nvim

# Unlink packages
bash stow.sh unlink nvim

# Relink after editing
bash stow.sh relink zsh

# Check status
bash stow.sh status

# List available packages
bash stow.sh list
```

### Available Packages

| Package | Files |
|---------|-------|
| `zsh` | `.zshrc`, `.zimrc`, `.p10k.zsh`, `.zshrc.local` |
| `tmux` | `.tmux.conf` |
| `nvim` | `.config/nvim/init.lua` |
| `shell` | `.profile`, `.bashrc` |
| `git` | `.gitconfig` |
| `editors` | `.config/zed/settings.json`, `.config/Cursor/User/settings.json` |

### Quick Edit Dotfiles

```bash
vim ~/dotfiles/stow/zsh/.zshrc      # Edit zsh config
vim ~/dotfiles/stow/nvim/.config/nvim/init.lua  # Edit nvim config
bash ~/dotfiles/stow.sh relink zsh  # Apply changes
```

---

## Quick Reference Card

```
NAVIGATION          HISTORY             EDITING
Ctrl+A  start       Ctrl+R  search      Ctrl+U  del left
Ctrl+E  end         Space   magic exp   Ctrl+K  del right
Ctrl+←→ word nav    ↑↓      substring   Ctrl+_  undo
Alt+T   swap words                      Alt+S   add sudo

SPECIAL             CLIPBOARD           TOOLS
Ctrl+X E  edit cmd  Ctrl+X C  copy      z       smart cd
Ctrl+X L  clear     C         pipe-copy fzf     fuzzy find
Ctrl+Q    amazon q  P         paste     lg      git TUI
```

---

## Tips & Tricks

1. **History expansion with space**: Type `!!` then space to see the expansion before executing

2. **Quick sudo**: Press `Alt+S` to prepend sudo to any command

3. **Edit long commands**: Press `Ctrl+X Ctrl+E` to open in nvim

4. **Copy command to clipboard**: `Ctrl+X Ctrl+C` copies current line

5. **Auto-correction**: Zsh will suggest corrections - press `y` to accept

6. **Directory stack**: Use `pushd`/`popd` or just `cd -` to go back

7. **Glob qualifiers**: `ls *(m-1)` lists files modified today

8. **Quick rename**: `zmv '*.txt' '*.md'` renames all at once

9. **Background jobs**: Append `&` to run in background, `fg` to bring back

10. **Suspend and resume**: `Ctrl+Z` suspends, `fg` resumes, `bg` runs in background

---

*Generated for Pop!_OS Zsh environment - Last updated: January 2026*
