
# Custom file picker with preview
fzf-file-widget() {
  local selected=$(fd --type f --hidden --follow --exclude .git | \
    fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' \
        --preview-window right:60% \
        --height 80%)
  
  if [[ -n $selected ]]; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle reset-prompt
}

zle -N fzf-file-widget
bindkey '^F' fzf-file-widget  # Bind to CTRL-F

# Enable fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
