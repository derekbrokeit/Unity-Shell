
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

# edit binding
bindkey "^W" vi-backward-kill-word 

# bored? try tetris
autoload -U tetris
zle -N tetris
bindkey "^T" tetris

# history search
bindkey -M viins "^r" history-incremental-search-backward

