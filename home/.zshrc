# ── History ──────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory share_history hist_ignore_dups hist_ignore_space

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode disabled
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ── Pacman plugins (outside OMZ's plugin dir — source manually) ─────────────
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # keep LAST
[[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# ── History substring search keybinds ────────────────────────────────────────
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# ── Paths ────────────────────────────────────────────────────────────────────
path=(~/.cargo/bin $path)

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
