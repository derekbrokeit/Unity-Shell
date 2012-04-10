
# vi-mode
bindkey -v

# history search
autoload -z history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# tab completion history menu (vicmd)
autoload -z history-beginning-search-menu
zle -N history-beginning-search-menu-space-end history-beginning-search-menu
bindkey -M vicmd "\t"  history-beginning-search-menu-space-end

# clear the screen
bindkey "^L" clear-screen
bindkey "\e^L" clear-screen

# undo
bindkey "^_" undo
bindkey '^x' reverse-menu-complete

# edit binding
bindkey "^W" vi-backward-kill-word

# bored? try tetris
autoload -U tetris
zle -N tetris
bindkey "^T" tetris

# history search
bindkey -M viins "^r" history-incremental-search-backward

# open EDITOR from comandline
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd ":e" edit-command-line
bindkey -M viins "^o" edit-command-line

# show history
function zle-show-my-recent-history(){
echo ""
history

zle reset-prompt
zle vi-insert
}
zle -N zle-show-my-recent-history
bindkey -M vicmd '!' zle-show-my-recent-history
