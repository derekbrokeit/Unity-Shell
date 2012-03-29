
# vi-mode
bindkey -v

# history search
bindkey "^p" history-beginning-search-backward
bindkey "^n" history-beginning-search-forward

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

