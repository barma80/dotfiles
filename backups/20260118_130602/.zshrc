# ============================================================================
#                           ZSH CONFIGURATION
#                    Pop!_OS Optimized Shell Setup
#          Based on best practices from Zsh tutorial transcripts
# ============================================================================

# ============================================================================
# POWERLEVEL10K INSTANT PROMPT (must be at the very top)
# ============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# AMAZON Q PRE-INIT
# ============================================================================

# Amazon Q pre-init for qterm wrapper
if command -v q &>/dev/null; then
    eval "$(q init zsh pre)" 2>/dev/null
fi

# ============================================================================
# XDG BASE DIRECTORIES
# ============================================================================

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Create cache directory for zsh
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

# ============================================================================
# ZIM FRAMEWORK INITIALIZATION
# ============================================================================

ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"

# Download zimfw plugin manager if missing
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update init.zsh if outdated
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
    source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules
source ${ZIM_HOME}/init.zsh

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export PAGER="${PAGER:-less}"
export LESS='-R -F -X -i -M -S -x4 -z-4'
export MANPAGER="less -R"

# Ensure path array is unique
typeset -U path PATH

# Add directories to path
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "/usr/local/go/bin"
    "$HOME/.bun/bin"
    $path
)

# ============================================================================
# HISTORY CONFIGURATION
# From transcript: "Share history between different terminals"
# ============================================================================

HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=100000
SAVEHIST=100000

# History options
setopt EXTENDED_HISTORY          # Write timestamps to history
setopt SHARE_HISTORY             # Share history between terminals (KEY FEATURE)
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicates when adding new
setopt HIST_FIND_NO_DUPS         # Don't display duplicates in search
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates to file
setopt HIST_REDUCE_BLANKS        # Remove extra blanks
setopt HIST_VERIFY               # Show command before executing from history
setopt INC_APPEND_HISTORY        # Add commands immediately

# ============================================================================
# ZSH OPTIONS
# From transcript: "setopt correct" for auto-correction
# ============================================================================

# Auto-correction (KEY FEATURE from transcript)
setopt CORRECT                   # Correct commands
setopt CORRECT_ALL               # Correct all arguments

# Directory navigation
setopt AUTO_CD                   # cd without typing cd
setopt AUTO_PUSHD                # Push directories to stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_SILENT              # Don't print directory stack
setopt CDABLE_VARS               # cd to named directories

# Globbing (from transcript: extended pattern matching)
setopt EXTENDED_GLOB             # Extended globbing syntax
setopt NULL_GLOB                 # No error if glob matches nothing
setopt GLOB_DOTS                 # Include dotfiles in globs

# Completion
setopt COMPLETE_IN_WORD          # Complete from cursor position
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt LIST_PACKED               # Pack completion list
setopt LIST_ROWS_FIRST           # Sort completions horizontally
setopt AUTO_MENU                 # Show menu on second tab
setopt MENU_COMPLETE             # Insert first match immediately

# Misc
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shell
setopt NO_BEEP                   # No beeping
setopt NO_FLOW_CONTROL           # Disable flow control (Ctrl+S/Q)
setopt PROMPT_SUBST              # Enable prompt substitution

# ============================================================================
# COMPLETION SYSTEM
# Note: compinit is called by Zim's completion module, so we only add styling
# ============================================================================

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

# Formatting
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ============================================================================
# KEY BINDINGS
# From transcript: Navigation and editing shortcuts
# ============================================================================

# Use Emacs key bindings (use bindkey -v for Vi mode from transcript)
bindkey -e

# Edit command in $EDITOR (Ctrl+X, Ctrl+E)
# From transcript: "Open the current command in the default editor"
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Word navigation
bindkey '^[[1;5C' forward-word        # Ctrl+Right
bindkey '^[[1;5D' backward-word       # Ctrl+Left
bindkey '^H' backward-kill-word       # Ctrl+Backspace
bindkey '^[[3;5~' kill-word           # Ctrl+Delete

# History substring search (if plugin loaded)
if (( ${+widgets[history-substring-search-up]} )); then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
fi

# Undo (Ctrl+Shift+Underscore)
# From transcript: "Ctrl+Shift+Underscore undo the last operation"
bindkey '^_' undo

# Magic space: expand history on space
# From transcript: "Magic space widget which allows you to expand any historical command"
bindkey ' ' magic-space

# Push current buffer (Ctrl+Q)
# From transcript: "Ctrl+Q will remove the command from buffer... after hitting enter it pops back"
bindkey '^Q' push-line-or-edit

# Beginning and end of line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Delete line (Ctrl+U and Ctrl+K)
# From transcript: "Ctrl+U deletes everything, Ctrl+K deletes from cursor to right"
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# Transpose words (Alt+T)
# From transcript: "Alt+T to swap words"
bindkey '^[t' transpose-words

# ============================================================================
# ALIASES - REGULAR
# ============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# List files with colors (prefer eza > lsd > ls)
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza -T --icons --level=2'
    alias lta='eza -Ta --icons --level=2'
elif command -v lsd &>/dev/null; then
    alias ls='lsd --group-directories-first'
    alias ll='lsd -la --group-directories-first'
    alias la='lsd -a --group-directories-first'
    alias lt='lsd --tree --depth=2'
else
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
    alias la='ls -a --color=auto'
fi

# Better cat with bat
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat --plain'
fi

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate -10'
alias gla='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gst='git stash'
alias gstp='git stash pop'

# TUI applications
alias lg='lazygit'
alias y='yazi'
alias top='btop'
alias vim='nvim'
alias vi='nvim'

# Safety nets
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Misc
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# ============================================================================
# ALIASES - SUFFIX
# From transcript: "Open files by extension without specifying command"
# ============================================================================

# Text files -> Editor
alias -s {txt,md,markdown}=$EDITOR
alias -s {json,yaml,yml,toml,ini,cfg,conf}=$EDITOR
# Note: Shell scripts (.sh, .bash, .zsh) are NOT included here
# so they execute instead of opening in editor
alias -s {fish}=$EDITOR
alias -s {py,rb,pl,php}=$EDITOR
alias -s {js,ts,jsx,tsx,vue,svelte}=$EDITOR
alias -s {go,rs,c,cpp,h,hpp}=$EDITOR
alias -s {html,htm,css,scss,sass,less}=$EDITOR
alias -s Makefile=$EDITOR

# Log files -> less with follow
alias -s log='less +F'

# Archives -> extract
alias -s {gz,tgz,bz2,tbz,xz,txz,zip,rar,7z}=extract

# ============================================================================
# ALIASES - GLOBAL
# From transcript: "Global aliases that can be used anywhere in command"
# ============================================================================

# Null output
alias -g NE='2>/dev/null'           # Null errors
alias -g NO='>/dev/null'            # Null output
alias -g NUL='>/dev/null 2>&1'      # Null all

# Piping
alias -g J='| jq'                   # Pipe to jq
alias -g JC='| jq -C'               # Pipe to jq with color
alias -g L='| less'                 # Pipe to less
alias -g LR='| less -R'             # Pipe to less with colors
alias -g G='| grep'                 # Pipe to grep
alias -g GI='| grep -i'             # Pipe to grep (case insensitive)
alias -g H='| head'                 # Pipe to head
alias -g T='| tail'                 # Pipe to tail
alias -g TF='| tail -f'             # Pipe to tail -f
alias -g S='| sort'                 # Pipe to sort
alias -g SU='| sort -u'             # Pipe to sort unique
alias -g WC='| wc -l'               # Pipe to word count

# Clipboard (Wayland/X11)
if command -v wl-copy &>/dev/null; then
    alias -g C='| wl-copy'
    alias -g P='$(wl-paste)'
elif command -v xclip &>/dev/null; then
    alias -g C='| xclip -selection clipboard'
    alias -g P='$(xclip -selection clipboard -o)'
fi

# ============================================================================
# NAMED DIRECTORIES
# From transcript: "Bookmark directories with ~alias syntax"
# ============================================================================

hash -d projects=~/projects
hash -d config=~/.config
hash -d downloads=~/Downloads
hash -d documents=~/Documents
hash -d desktop=~/Desktop

# ============================================================================
# CUSTOM FUNCTIONS
# ============================================================================

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find files by name
ff() {
    find . -type f -iname "*$1*" 2>/dev/null
}

# Find directories by name
fdir() {
    find . -type d -iname "*$1*" 2>/dev/null
}

# Extract archives (used by suffix alias)
extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <file>"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        echo "'$1' is not a valid file"
        return 1
    fi

    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.tar.xz)    tar xJf "$1"     ;;
        *.tar.zst)   tar --zstd -xf "$1" ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
}

# Quick backup of a file
bak() {
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# Show top 10 most used commands
top10() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
}

# ============================================================================
# CUSTOM WIDGETS (ZLE)
# From transcript: "Create custom terminal actions with ZLE"
# ============================================================================

# Copy command line to clipboard (Ctrl+X, Ctrl+C)
copy-line-to-clipboard() {
    if command -v wl-copy &>/dev/null; then
        echo -n "$BUFFER" | wl-copy
    elif command -v xclip &>/dev/null; then
        echo -n "$BUFFER" | xclip -selection clipboard
    else
        zle -M "No clipboard tool available"
        return 1
    fi
    zle -M "Copied to clipboard: $BUFFER"
}
zle -N copy-line-to-clipboard
bindkey '^X^C' copy-line-to-clipboard

# Clear screen but preserve current buffer (Ctrl+X, Ctrl+L)
clear-screen-preserve-buffer() {
    local saved_buffer="$BUFFER"
    local saved_cursor="$CURSOR"
    clear
    BUFFER="$saved_buffer"
    CURSOR="$saved_cursor"
    zle redisplay
}
zle -N clear-screen-preserve-buffer
bindkey '^X^L' clear-screen-preserve-buffer

# Insert sudo at beginning of line (Alt+S)
insert-sudo() {
    if [[ "$BUFFER" != "sudo "* ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$((CURSOR + 5))
    fi
}
zle -N insert-sudo
bindkey '^[s' insert-sudo

# ============================================================================
# CHPWD HOOKS
# From transcript: "Execute commands when changing directories"
# ============================================================================

autoload -Uz add-zsh-hook

# Auto-activate Python virtualenv
_auto_venv() {
    # Deactivate if we leave the venv directory
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_parent="${VIRTUAL_ENV%/*}"
        venv_parent="${venv_parent%/.venv}"
        venv_parent="${venv_parent%/venv}"
        if [[ ! "$PWD" == "$venv_parent"* ]]; then
            deactivate 2>/dev/null
        fi
    fi

    # Activate if we enter a directory with venv
    if [[ -z "$VIRTUAL_ENV" ]]; then
        if [[ -d ".venv" && -f ".venv/bin/activate" ]]; then
            source .venv/bin/activate
        elif [[ -d "venv" && -f "venv/bin/activate" ]]; then
            source venv/bin/activate
        fi
    fi
}
add-zsh-hook chpwd _auto_venv

# Auto-load nvm if .nvmrc exists
_auto_nvm() {
    if [[ -f ".nvmrc" ]] && command -v nvm &>/dev/null; then
        local nvmrc_node_version
        nvmrc_node_version=$(cat .nvmrc)
        local current_node_version
        current_node_version=$(node --version 2>/dev/null || echo "")

        if [[ "$nvmrc_node_version" != "$current_node_version" ]]; then
            nvm use 2>/dev/null
        fi
    fi
}
add-zsh-hook chpwd _auto_nvm

# ============================================================================
# ZMV - BATCH FILE OPERATIONS
# From transcript: "ZMV advanced file moving with pattern matching"
# ============================================================================

autoload -Uz zmv

# Simplified zmv aliases with -W flag for simple patterns
alias zmv='noglob zmv -W'
alias zcp='noglob zmv -C -W'
alias zln='noglob zmv -L -W'

# Dry run versions (add -n for no exec)
alias zmvn='noglob zmv -W -n'
alias zcpn='noglob zmv -C -W -n'
alias zlnn='noglob zmv -L -W -n'

# ============================================================================
# TOOL INTEGRATIONS
# ============================================================================

# Zoxide (smart cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# FZF (fuzzy finder)
if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --info=inline
        --marker="*"
        --pointer=">"
        --color=dark
        --color=fg:-1,bg:-1,hl:#5fff87
        --color=fg+:-1,bg+:-1,hl+:#ffaf5f
        --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7
        --color=marker:#ff87d7,spinner:#ff87d7
    '

    # Use fd if available
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    # Load fzf keybindings
    [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
fi

# Atuin (shell history)
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# ============================================================================
# ENVIRONMENT INTEGRATIONS
# (Preserved from common .bashrc setups)
# ============================================================================

# Cargo (Rust)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Local bin scripts
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# NVM (Node Version Manager) - Lazy loaded for faster startup
export NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR" ]]; then
    # Lazy load nvm
    nvm() {
        unfunction nvm 2>/dev/null
        [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
        nvm "$@"
    }

    # Also lazy load node, npm, npx, etc.
    for cmd in node npm npx yarn pnpm; do
        eval "$cmd() { unfunction $cmd 2>/dev/null; nvm; $cmd \"\$@\" }"
    done
fi

# Pyenv (Python Version Manager)
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT" ]]; then
    path=("$PYENV_ROOT/bin" $path)
    eval "$(pyenv init -)" 2>/dev/null
    eval "$(pyenv virtualenv-init -)" 2>/dev/null
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL" ]] && path=("$BUN_INSTALL/bin" $path)

# Go
export GOPATH="${GOPATH:-$HOME/go}"
export GOROOT="${GOROOT:-/usr/local/go}"

# ============================================================================
# VI MODE (Optional)
# From transcript: "Switch key mappings from Emacs to Vim"
# Uncomment the following to enable Vi mode
# ============================================================================

# bindkey -v
# export KEYTIMEOUT=1
#
# # Vi mode indicator in prompt (optional)
# function zle-keymap-select {
#     case $KEYMAP in
#         vicmd) echo -ne '\e[1 q';;      # Block cursor
#         viins|main) echo -ne '\e[5 q';; # Beam cursor
#     esac
# }
# zle -N zle-keymap-select
#
# # Reset cursor on startup
# echo -ne '\e[5 q'

# ============================================================================
# AMAZON Q CLI INTEGRATION
# Type-ahead and AI assistance for terminal commands
# ============================================================================

if command -v q &>/dev/null; then
    # Source Amazon Q's post-init script for inline completions/type-ahead
    # This must be sourced AFTER all other shell configuration
    eval "$(q init zsh post)"

    # Aliases for quick access
    alias qa='q chat'
    alias qt='q translate'

    # Ctrl+Q to launch Amazon Q chat
    amazon-q-widget() {
        BUFFER="q chat"
        zle accept-line
    }
    zle -N amazon-q-widget
    bindkey '^Q' amazon-q-widget
fi

# ============================================================================
# LOCAL CUSTOMIZATIONS
# ============================================================================

# Source local customizations (not tracked in git)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Source secrets (API keys, tokens, etc.)
[[ -f "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"

# Run auto_venv on shell start
_auto_venv

# ============================================================================
# POWERLEVEL10K CONFIGURATION
# ============================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# END OF CONFIGURATION
# ============================================================================
