#!/usr/bin/env zsh
set -e
 
CURRENT_USER="$(id -un)"
USER_HOME="$(eval echo ~${CURRENT_USER})"
 
ZSHRC="${USER_HOME}/.zshrc"
TMUX_CONF="${USER_HOME}/.tmux.conf"
 
 
 
 
 
if ! command -v brew >/dev/null 2>&1; then
  echo "[*] Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "[*] Homebrew already installed"
fi
 
echo "[*] Installing Neovim and tmux"
brew install neovim tmux fzf wget
 
 
echo "[*] Setting up Lazyvim"
git clone https://github.com/jchauhn/lazyvim ~/.config/nvim

echo "[*] Setting up tmux config"
 
cat <<'EOF' > "${TMUX_CONF}"
# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-s
bind-key C-s send-prefix
set -g mouse on

bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-cancel "pbcopy"
bind -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

 
 
# set-option -g default-path "#{pane_current_path}"
 
bind | split-window -h
bind _ split-window -v
# True color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
 
# Enable colors
set -g default-terminal "screen-256color"
 
# Status bar colors
set -g status-style bg=colour235,fg=white
 
# True color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
 
# Enable colors
set -g default-terminal "screen-256color"
 
# Status bar colors
set -g status-style bg=colour235,fg=white
EOF
 
# Reload tmux config if inside tmux
 
 
 
 
cat <<'EOF' > "${ZSHRC}"
# Enable colored output
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
 
# Aliases for color support
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
 
# History file
HISTFILE=$USER_HOME/.zsh_history
 
# Big numbers = effectively unlimited
HISTSIZE=100000000
SAVEHIST=100000000
 
# Share history across all terminals
setopt SHARE_HISTORY
 
# Append history instead of overwriting
setopt APPEND_HISTORY
 
# Save history immediately
setopt INC_APPEND_HISTORY
 
# Save timestamps (useful for searching later)
setopt EXTENDED_HISTORY
# Don’t store duplicates
 
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
 
alias hist="cat ~/.zsh_history | uniq | fzf"
EOF
 
 
source "${ZSHRC}"
echo "=== Done ==="
 
