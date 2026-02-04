# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/bashrc.pre.bash"
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
. "$HOME/.cargo/env"

. "$HOME/.local/bin/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

# Amazon Q Configuration - Type-ahead and AI assistance
if command -v q >/dev/null 2>&1 || command -v amazon-q >/dev/null 2>&1; then
    # Set up Amazon Q CLI
    export AMAZON_Q_ENABLED=1
    
    # Initialize Amazon Q autocomplete (if supported in future versions)
    # Note: Current Amazon Q CLI doesn't support --completion flag
    # Uncomment below when Amazon Q adds completion support:
    # if command -v q >/dev/null 2>&1; then
    #     eval "$(q --completion bash)" 2>/dev/null || true
    # elif command -v amazon-q >/dev/null 2>&1; then
    #     eval "$(amazon-q --completion bash)" 2>/dev/null || true
    # fi
    
    # Amazon Q type-ahead function
    q_typeahead() {
        local query="$*"
        if [ -z "$query" ]; then
            q --interactive
        else
            q "$query"
        fi
    }
    
    # Create aliases for quick access
    alias qa='q --ask'
    alias qi='q --interactive'
    alias qc='q --code'
    alias qd='q --document'
    
    # Enable type-ahead in terminal
    bind '"\C-q": "q --interactive\n"'
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# Cloudflare API credentials for tristack.net
export CLOUDFLARE_ZONE_ID="7de22851d3e57d041ad663b669868d61"
export CLOUDFLARE_API_TOKEN="oUW1U6L9L7h9FF_nudbaVnknOU0oARJwDdeHOdE_"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# pyenv shell integration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/home/barma80/.opencode/bin:$PATH

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/bashrc.post.bash" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/bashrc.post.bash"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Android Development
[ -f ~/.android-env ] && source ~/.android-env

# Quick browser hang recovery
alias browser-fix="~/projects/pop-os-config/scripts/102-browser-hang-recovery.sh"

# MuseBook Development
# Added by musebook-riscv-setup

# Quick SSH access
alias mb='ssh musebook'
alias mbt='ssh -t musebook "htop"'
alias mbinfo='ssh musebook "neofetch 2>/dev/null || uname -a"'

# Development workflow
alias mbs='musebook-sync'
alias mbb='musebook-build'
alias mbbr='musebook-build . release'
alias mbd='musebook-build . debug'
alias mbtst='musebook-test'
alias mbbnch='musebook-bench'
alias mbsh='musebook-shell'
alias mbclaude='musebook-claude'

# Quick project access
alias aiden='cd ~/aiden-riscv-lab'

# Workflow function: edit locally, build on musebook
mb-dev() {
    local cmd="$1"
    case "$cmd" in
        sync)  musebook-sync . ;;
        build) musebook-build . ;;
        test)  musebook-test . ;;
        bench) musebook-bench . ;;
        shell) musebook-shell ;;
        *)     echo "Usage: mb-dev {sync|build|test|bench|shell}" ;;
    esac
}
alias ai-assist='flatpak run moe.nyarchlinux.assistant'
