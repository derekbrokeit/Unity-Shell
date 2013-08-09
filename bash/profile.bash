##LS_COLORS for Linux
#export LS_COLORS="di=01;32:ln=01;35:so=01;34:pi=01;33:ex=01;31:bd=37;46:cd=43;34:"
## Shell variables
### Colors
## less important are the colors ...
## this may only work on OSX
#export CLICOLOR=1
#export LSCOLORS=CxFxExDxBxegedabagacad
##1. directory
##2. symbolic link
##3. socket
##4. pipe
##5. executable
##6. block special
##7. character special
##8. executable with setuid bit set
##9. executable with setgid bit set
##10.directory writable to others, with sticky bit
##11.directory writable to others, without sticky bit
##
##a  black
##b  red
##c  green
##d  brown
##e  blue
##f  magenta
##c  cyan
##h  light grey
##A  block black, usually shows up as dark grey
##B  bold red
##C  bold green
##D  bold brown, usually shows up as yellow
##E  bold blue
##F  bold magenta
##G  bold cyan
##H  bold light grey; looks like bright white
##x  default foreground or background

PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv -g TMUX_PWD_$(tmux display -p "#D") "$PWD")'

