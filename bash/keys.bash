# better input method
# setup vi input method for readLine
# set -o vi
set editing-mode vi
set keymap vi-insert
# ^p check for partial match in history
bind -m vi-insert "\C-p":dynamic-complete-history
# ^n cycle through the list of partial matches
bind -m vi-insert "\C-n":menu-complete
# ^l clear screen
bind -m vi-insert "\C-l":clear-screen
# fix C-S
stty stop undef # to unmap ctrl-s
