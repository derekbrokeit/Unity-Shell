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

# PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv -g TMUX_PWD_$(tmux display -p "#D") "$PWD")'

# # PS1='$(_prompt_topline) %{$(reset_tmux_window)%}${PR_RESET}%(!.%B%F{red}%#%f%b.%B${VI_MODE}%%%f%b) ${PR_RESET}'
# setup main prompt (vi-color changing)
ENDL=$'\n'
function _cmd_status() {
    local s=$(printf "%03d" $?)
    local color=${RED}
    if [[ $s -eq 0 ]] ; then
        color=${GREEN}
    fi
    echo -n "${color}${s}${NC}"
}
function _git_status() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ -n $branch ]] ; then
        branch=${MAGENTA}${branch}

        local tracker=$(git rev-list --left-right --boundary "@{u}...HEAD" 2> /dev/null)
        local behind=$(echo $tracker | egrep "^<" | wc -l)
        local ahead=$(echo $tracker | egrep "^>" | wc -l)

        local gst=$(git status --porcelain 2> /dev/null)
        local total=$(echo -n "$gst" | egrep "" | wc -l)
        if [[ $total -eq 0 ]] ; then
            local s="${GREEN}✔"
        else
            local unmer=$(echo -n "$gst" | egrep "^(DD|AU|UD|UA|DU|AA|UU)" | wc -l)
            local stage=$(($(echo -n "$gst" | egrep "^[[:alpha:]]" | wc -l) - $unmer))
            local unstg=$(echo -n "$gst" | egrep "^ [[:alpha:]]" | wc -l)
            local other=$(($total - $(($stage + $unstg))))

            local s=""
            if [[ $unmer -gt 0 ]] ; then
                s=$(printf "${s}${RED_BRIGHT}% 3d○" $unmer)
            fi
            if [[ $stage -gt 0 ]] ; then
                s=$(printf "${s}${GREEN}% 3d●" $stage)
            fi
            if [[ $unstg -gt 0 ]] ; then
                s=$(printf "${s}${YELLOW}% 3d✚" $unstg)
            fi
            if [[ $other -gt 0 ]] ; then
                s=$(printf "${s}${RED}% 3d…" $other)
            fi
        fi

        local change=""
        if [[ $ahead -gt 0 ]] ; then
            if [[ $behind -gt 0 ]] ; then
                change=$(printf "↑%d↓%d" $ahead $behind)
            else
                change=$(printf "↑%d" $ahead)
            fi
        elif [[ $behind -gt 0 ]] ; then
            change=$(printf "↓%d" $ahead $behind)
        else
            change="☰"
        fi
        echo -n "(${branch}${CYAN}${change}${NC}|$s${NC})"
    fi

}
function _now() {
    date +"%R"
}
function _virtual_env() {
    if [ -n "${VIRTUAL_ENV}" ] ; then
        echo -n "($(basename $VIRTUAL_ENV))"
    fi
}
function _prompt_topline () {
    local c_status=$(_cmd_status)
    local g_status=$(_git_status)
    local now=$(_now)

    echo -en "${ENDL}${RESET}${c_status} ${YELLOW}${PWD}${RESET} ${g_status} $(_virtual_env)${ENDL}${BLACK_BRIGHT}${now}"
}

# set the prompt
PS1='$(_prompt_topline) ${CYAN}\$${NC} '

# disable automatic updating of prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# # help with autojump
# export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
if [ -f /usr/share/autojump/autojump.bash ] ; then
    . /usr/share/autojump/autojump.bash
fi
