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

# more colors
# insipired by: https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/
typeset -Ag fx fg_all bg_all

# first attributes
fx=(
    reset        "[00m" 0 "[00m"  name0  RESET
    bold         "[01m" 1 "[01m"  name1  BOLD
    no-bold      "[22m" 2 "[22m"  name2  NO_BOLD
    italic       "[03m" 3 "[03m"  name3  ITALIC
    no-italic    "[23m" 4 "[23m"  name4  NO_ITALIC
    underline    "[04m" 5 "[04m"  name5  UNDERLINE
    no-underline "[24m" 6 "[24m"  name6  NO_UNDERLINE
    blink        "[05m" 7 "[05m"  name7  BLINK
    no-blink     "[25m" 8 "[25m"  name8  NO_BLINK
    reverse      "[07m" 9 "[07m"  name9  REVERSE
    no-reverse   "[27m" 10 "[27m" name10 NO_REVERSE
)
# setup attribute markers ie. $BLINK
for i in {0..10} ; do
  eval ${fx[name$i]}=${fx[$i]}
done

# now grab 256 color markers
for color in {000..255}; do
    fg_all[$color]="[38;5;${color}m"
    bg_all[$color]="[48;5;${color}m"
done

# define the color of severe errors
ERROR_RED="$fg_all[196]"
PR_ERROR_RED="%{$ERROR_RED%}" # escaped ERROR_RED

