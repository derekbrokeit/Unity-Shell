
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
bindkey "^W" delete-word 

# bored? try tetris
autoload -U tetris
zle -N tetris
bindkey "^T" tetris

