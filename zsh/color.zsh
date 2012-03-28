# color names are generall as follows::
# USE_COLRNAME_ADJECTIVE_BG
# examples:
# PR_RED_BRIGHT_BG: Prompt > red    > bright > background
# RED_BRIGHT:                red    > bright

autoload -U colors && colors
# set some colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN BLUE; do
  eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
  eval PR_${COLOR}_BRIGHT='%{$fg_bold[${(L)COLOR}]%}'
  eval ${COLOR}='$fg_no_bold[${(L)COLOR}]'
  eval ${COLOR}_BRIGHT='$fg_bold[${(L)COLOR}]'
  eval ${COLOR}_BG='$bg_no_bold[${(L)COLOR}]'
  eval ${COLOR}_BRIGHT_BG='$bg_bold[${(L)COLOR}]'
done
PR_RESET="%{${reset_color}%}";
NC="${reset_color}";
ERROR_RED="\e[38;5;196m"
PR_ERROR_RED="%{$ERROR_RED%}"

#setup ~/.dir_colors if one doesn\'t exist
if [ ! -s ~/.dir_colors ]; then
  dircolors -p > ~/.dir_colors
fi
eval `dircolors ~/.dir_colors`

# grep coloring
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# colorful man-pages
# Less Colors for Man Pages
export LESS="-R"
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline


### ls color options 
#####################
# export LS_OPTIONS="--color=auto"
#LS_COLORS for Linux
# export LS_COLORS="di=01;32:ln=01;35:so=01;34:pi=01;33:ex=01;31:bd=37;46:cd=43;34:"
# # Shell variables
# ## Colors
# # less important are the colors ...
# # this may only work on OSX
# export CLICOLOR=1
# export LSCOLORS=CxFxExDxBxegedabagacad
# #1. directory
# #2. symbolic link
# #3. socket
# #4. pipe
# #5. executable
# #6. block special
# #7. character special
# #8. executable with setuid bit set
# #9. executable with setgid bit set
# #10.directory writable to others, with sticky bit
# #11.directory writable to others, without sticky bit
# #
# #a  black
# #b  red
# #c  green
# #d  brown
# #e  blue
# #f  magenta
# #c  cyan
# #h  light grey
# #A  block black, usually shows up as dark grey
# #B  bold red
# #C  bold green
# #D  bold brown, usually shows up as yellow
# #E  bold blue
# #F  bold magenta
# #G  bold cyan
# #H  bold light grey; looks like bright white
# #x  default foreground or background

# print a block of colors with numbers
show-colors() {
  for line in {0..17}; do
    for col in {0..15}; do
      code=$(( $col * 18 + $line ));
      printf $'\e[38;05;%dm %03d' $code $code;
    done;
    echo;
  done
}
# printcolor: print the available 256 colors
function show-colors-list() {
# the colour codes will work in tmux
printf "\ttmux-fg \t\t tmux-bg \t [bash(fg=\\ x1b[38;5;\${i}  bg=\\ x1b[48;5;\${i}m )]\n"
for i in {0..255} ; do
  printf "\x1b[38;5;${i}m i=${i} \tcolour${i}\e[0m \t\x1b[48;5;${i}m\tcolour${i} \t\e[0m\n"
done
}

