# color names are generall as follows::
# USE_COLRNAME_ADJECTIVE_BG
# examples:
# PR_RED_BRIGHT_BG: Prompt > red    > bright > background
# RED_BRIGHT:                red    > bright

autoload -U colors && colors
# set some colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN BLUE MAGENTA; do
  eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
  eval PR_${COLOR}_BRIGHT='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}";

# more colors
# insipired by: https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/
typeset -Ag fx fg_all bg_all

# now grab 256 color markers
for color in {000..255}; do
    fg_all[$color]="[38;5;${color}m"
    bg_all[$color]="[48;5;${color}m"
done

# define the color of severe errors
PR_ERROR_RED="%{$ERROR_RED%}" # escaped ERROR_RED
