setopt prompt_subst

# changes the color of the prompt based on the hostname
HASH_NUM=$(echo $HOSTNAME | md5sum | tr -d 'a-f' | cut -b 1-6)
HASH_COLOR=$(($HASH_NUM % 6 + 2 + 8 ))
HASH_COLOR2=$(($HASH_NUM % 6 + 2 + 8 + 1 ))
if [[ $HASH_COLOR -lt 10 ]] ; then
  HASH_MOD="%{$fg_all[00${HASH_COLOR}]%}"
elif [[ $HASH_COLOR -lt 100 ]] ; then
  HASH_MOD="%{$fg_all[0${HASH_COLOR}]%}"
else
  HASH_MOD="%{$fg_all[${HASH_COLOR}]%}"
fi
# an additional color
if [[ $HASH_COLOR2 -lt 10 ]] ; then
  HASH_MOD2="%{$fg_all[00${HASH_COLOR2}]%}"
elif [[ $HASH_COLOR2 -lt 100 ]] ; then
  HASH_MOD2="%{$fg_all[0${HASH_COLOR2}]%}"
else
  HASH_MOD2="%{$fg_all[${HASH_COLOR2}]%}"
fi

if [[ $(whoami) = root ]]; then
  PROMPT_LINE="${PR_RED_BRIGHT}%n${PR_DEFAULT}@${PR_YELLOW_BRIGHT}%M%f%b"
else
  if [[ $COMP_TYPE == "local" ]] ; then
    PROMPT_LINE="%B${HASH_MOD}%m%b"
  else
    PROMPT_LINE="%B${HASH_MOD}$(hostname | cut -c 1)%b"
  fi
fi

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
  

# load the git-prompt which gives information on the repo
. $HOME/.zsh/git-prompt/zshrc.sh
ZSH_THEME_GIT_PROMPT_NOCACHE="1"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg_bold[red]%}+"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"

# initial vi-color: first prompt starts in insert-mode
KEYMAP_VI_CMD=${PR_RED_BRIGHT}
KEYMAP_VI_INS=${PR_GREEN_BRIGHT}
KEYMAP_VI_REP=${PR_BLUE_BRIGHT}
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


# setup main prompt
PROMPT='%{$(reset_tmux_window)%}${PROMPT_LINE}${PR_GREEN}:${PR_RESET}$(git_super_status)%(!.%B%F{red}%#%f%b.%B${VI_MODE}$%f%b) ${PR_RESET}'


function secondary_prompt(){
pr_unescape=$(print -Pn $PROMPT | sed -r "s/\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g ; s/kzsh\\\//g") 
pr_len=${#pr_unescape}
spaces=$(print "${(l:(pr_len):: :)}\b\b\b\b\b···")
pr="${PR_BLACK_BRIGHT}${spaces}${PR_CYAN_BRIGHT}>${PR_RESET} " 
echo $pr 

}
# secondary prompt
# (( TERMWIDTH = ${COLUMNS} - 2 ))
# PROMPT_ESCAPED=$(echo $PROMPT | sed 's/\$(\w*)//g')
# PROMPT_ESCAPED=${(%e)PROMPT_ESCAPED}
# PROMPT_LENGTH=${#${PROMPT_ESCAPED//\[[^m]##m/}}
# FILL_SPACES=${(l:PROMPT_LENGTH:: :)}
PROMPT2='$(secondary_prompt)'


