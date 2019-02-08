setopt prompt_subst

HASH_MOD=$PR_YELLOW_BRIGHT
HASH_MOD2=$PR_BLUE_BRIGHT

# printing the title
precmd(){  print -Pn "\e]2;%m: %~\a" }

case $TERM in
  screen*)
    # this governs the tmux window name
    # the sed pipe checks for asignment
    # previously "preexex: parse error" was thrown when making assignments
    #     the error occured because: vi=$(print "hello") --> vi=$(print
    #     this causes preexec to throw a parse error because the parentheses are not closed
    #     If more cases beyond asignment cause this, I may need to fix that further
    preexec(){ print -Pn "\033k$(basename ${1[(w)1]} | sed 's/\(\w*\)=.*/\1=\.\.\./g')\033\\" }
    ;;
  *)
    preexec(){ print -Pn "\e]2;%m: %~\a" }
    ;;
esac
  
function reset_tmux_window(){
# reset the window name to it's former glory
  if [[ -n $TMUX ]] ; then
    print -Pn "\033kzsh\033\\"
  fi
}
  

# initial vi-color: first prompt starts in insert-mode
KEYMAP_VI_CMD=${PR_RED}
KEYMAP_VI_INS=${PR_GREEN}
KEYMAP_VI_REP=${PR_BLUE}
VI_MODE=${KEYMAP_VI_INS}

function zle-line-init zle-keymap-select {
local keymapTest
keymapTest="${${KEYMAP/vicmd/${KEYMAP_VI_CMD}}/(main|viins)/${KEYMAP_VI_INS}}"
if [[ ! ( $keymapTest == $KEYMAP_VI_INS && $VI_MODE == $KEYMAP_VI_REP ) ]] ; then
  VI_MODE=$keymapTest
fi

zle reset-prompt
}
function zle-vi-replace(){
# useful blog that helped lead to this answer:
# http://www.bewatermyfriend.org/posts/2010/08-08.21-16-02-computer.html
VI_MODE="${KEYMAP_VI_REP}"
zle vi-replace
zle reset-prompt
}
zle -N zle-vi-replace
zle -N zle-line-init
zle -N zle-keymap-select
bindkey -M vicmd 'R'   zle-vi-replace

# setup main prompt (vi-color changing)
ENDL=$'\n'
function _cmd_status() {
    local s=$(printf "%03d" $?)
    local color=${PR_RED}
    if [[ $s -eq 0 ]] ; then
        color=${PR_GREEN}
    fi
    echo -n "${color}${s}${PR_RESET}"
}
function _git_status() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ -n $branch ]] ; then
        branch=${MAGENTA}${branch}

        local tracker=$(git rev-list --left-right --boundary "@{u}...HEAD" 2> /dev/null)
        local behind=$(echo $tracker | egrep "^<" | wc -l)
        local ahead=$(echo $tracker | egrep "^>" | wc -l)

        local gst=$(git status --porcelain 2> /dev/null)
        local total=$(echo -n $gst | egrep "" | wc -l)
        if [[ $total -eq 0 ]] ; then
            local s="${GREEN}✔"
        else
            local unmer=$(echo -n $gst | egrep "^(DD|AU|UD|UA|DU|AA|UU)" | wc -l)
            local stage=$(($(echo -n $gst | egrep "^[[:alpha:]]" | wc -l) - $unmer))
            local unstg=$(echo -n $gst | egrep "^ [[:alpha:]]" | wc -l)
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
        echo -n " (${branch}${CYAN}${change}${NC}|$s${NC})"
    fi

}
function _now() {
    date +"%R"
}
function _virtual_env() {
    if [ -n "${VIRTUAL_ENV}" ] ; then
        echo -n " ($(basename $VIRTUAL_ENV))"
    fi
}
function _prompt_topline () {
    local c_status=$(_cmd_status)
    local g_status=$(_git_status)
    local now=$(_now)

    echo -en "${ENDL}${c_status} ${PR_YELLOW}${PWD}${PR_RESET}${g_status}$(_virtual_env)${ENDL}${BLACK_BRIGHT}${now}"
}

PROMPT='$(_prompt_topline) %{$(reset_tmux_window)%}${PR_RESET}%(!.%B%F{red}%#%f%b.%B${VI_MODE}%%%f%b) ${PR_RESET}'

# disable automatic updating of prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
