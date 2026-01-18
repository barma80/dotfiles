#!/usr/bin/env bash
# ============================================================================
# Dotfiles Stow Manager
# Uses GNU Stow to symlink dotfiles from this repo to home directory
# ============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$SCRIPT_DIR/stow"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if stow is installed
if ! command -v stow &>/dev/null; then
    log_error "GNU Stow is not installed!"
    echo ""
    echo "Install it with:"
    echo "  sudo apt install stow"
    exit 1
fi

# Available packages
PACKAGES=(zsh tmux nvim)

usage() {
    cat << EOF
Dotfiles Stow Manager

Usage: $0 <command> [packages...]

Commands:
    link        Create symlinks (stow packages)
    unlink      Remove symlinks (unstow packages)
    relink      Remove and recreate symlinks (restow)
    status      Show current symlink status
    list        List available packages

Packages: ${PACKAGES[*]}

Examples:
    $0 link                 # Link all packages
    $0 link zsh tmux        # Link specific packages
    $0 unlink nvim          # Unlink nvim only
    $0 relink zsh           # Relink zsh (after changes)
    $0 status               # Show status
EOF
}

# Backup existing files before stowing
backup_existing() {
    local package="$1"
    local backup_dir="$SCRIPT_DIR/backups/$(date +%Y%m%d_%H%M%S)"

    case "$package" in
        zsh)
            for f in ~/.zshrc ~/.zimrc ~/.p10k.zsh; do
                if [[ -f "$f" && ! -L "$f" ]]; then
                    mkdir -p "$backup_dir"
                    mv "$f" "$backup_dir/"
                    log_info "Backed up $f"
                fi
            done
            ;;
        tmux)
            if [[ -f ~/.tmux.conf && ! -L ~/.tmux.conf ]]; then
                mkdir -p "$backup_dir"
                mv ~/.tmux.conf "$backup_dir/"
                log_info "Backed up ~/.tmux.conf"
            fi
            ;;
        nvim)
            if [[ -f ~/.config/nvim/init.lua && ! -L ~/.config/nvim/init.lua ]]; then
                mkdir -p "$backup_dir"
                mkdir -p "$backup_dir/.config/nvim"
                mv ~/.config/nvim/init.lua "$backup_dir/.config/nvim/"
                log_info "Backed up ~/.config/nvim/init.lua"
            fi
            ;;
    esac
}

# Stow a package
stow_package() {
    local package="$1"

    if [[ ! -d "$STOW_DIR/$package" ]]; then
        log_error "Package '$package' not found in $STOW_DIR"
        return 1
    fi

    backup_existing "$package"

    log_info "Stowing $package..."
    stow -v -d "$STOW_DIR" -t "$HOME" "$package"
    log_success "Stowed $package"
}

# Unstow a package
unstow_package() {
    local package="$1"

    if [[ ! -d "$STOW_DIR/$package" ]]; then
        log_error "Package '$package' not found in $STOW_DIR"
        return 1
    fi

    log_info "Unstowing $package..."
    stow -v -D -d "$STOW_DIR" -t "$HOME" "$package"
    log_success "Unstowed $package"
}

# Restow a package (unstow then stow)
restow_package() {
    local package="$1"

    if [[ ! -d "$STOW_DIR/$package" ]]; then
        log_error "Package '$package' not found in $STOW_DIR"
        return 1
    fi

    log_info "Restowing $package..."
    stow -v -R -d "$STOW_DIR" -t "$HOME" "$package"
    log_success "Restowed $package"
}

# Show status
show_status() {
    echo ""
    echo "Stow Packages Status:"
    echo "====================="

    for package in "${PACKAGES[@]}"; do
        echo ""
        echo "[$package]"

        case "$package" in
            zsh)
                check_link ~/.zshrc
                check_link ~/.zimrc
                check_link ~/.p10k.zsh
                ;;
            tmux)
                check_link ~/.tmux.conf
                ;;
            nvim)
                check_link ~/.config/nvim/init.lua
                ;;
        esac
    done
    echo ""
}

check_link() {
    local file="$1"
    if [[ -L "$file" ]]; then
        local target=$(readlink "$file")
        echo -e "  ${GREEN}✓${NC} $file -> $target"
    elif [[ -f "$file" ]]; then
        echo -e "  ${YELLOW}○${NC} $file (regular file, not symlink)"
    else
        echo -e "  ${RED}✗${NC} $file (missing)"
    fi
}

# List packages
list_packages() {
    echo ""
    echo "Available packages:"
    for package in "${PACKAGES[@]}"; do
        echo "  - $package"
        case "$package" in
            zsh)  echo "      .zshrc, .zimrc, .p10k.zsh" ;;
            tmux) echo "      .tmux.conf" ;;
            nvim) echo "      .config/nvim/init.lua" ;;
        esac
    done
    echo ""
}

# Main
if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

COMMAND="$1"
shift

# Get packages (default to all if none specified)
if [[ $# -eq 0 ]]; then
    SELECTED_PACKAGES=("${PACKAGES[@]}")
else
    SELECTED_PACKAGES=("$@")
fi

case "$COMMAND" in
    link|stow)
        for pkg in "${SELECTED_PACKAGES[@]}"; do
            stow_package "$pkg"
        done
        ;;
    unlink|unstow)
        for pkg in "${SELECTED_PACKAGES[@]}"; do
            unstow_package "$pkg"
        done
        ;;
    relink|restow)
        for pkg in "${SELECTED_PACKAGES[@]}"; do
            restow_package "$pkg"
        done
        ;;
    status)
        show_status
        ;;
    list)
        list_packages
        ;;
    *)
        log_error "Unknown command: $COMMAND"
        usage
        exit 1
        ;;
esac
