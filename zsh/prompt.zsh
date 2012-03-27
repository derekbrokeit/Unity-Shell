setopt prompt_subst

# changes the color of the prompt based on the hostname
HASH_NUM=$(echo $HOSTNAME | md5sum | tr -d 'a-f' | cut -b 1-6)
HASH_MOD=$(($HASH_NUM % 6 + 2))
if [[ $(whoami) = root ]]; then
  PROMPT_LINE="${PR_BRIGHT_RED}%n${PR_DEFAULT}@${PR_BRIGHT_YELLOW}%M%f%b"
else
  PROMPT_LINE="%B%F{$HASH_MOD}%m%b"
fi

# printing the title
precmd(){  print -Pn "\e]2;%m: %~\a" }

case $TERM in
  screen*)
    # this governs the tmux window name
    preexec(){ print -Pn "\033k$(basename ${1[(w)1]})\033\\" }
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
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}+"

# initial vi-color: first prompt starts in insert-mode
VI_COLOR=${PR_BRIGHT_GREEN}
function zle-line-init zle-keymap-select {
# RPS1="${${KEYMAP/vicmd/${PR_GREEN}-- NORMAL --${PR_DEFAULT}}/(main|viins)/${PR_BRIGHT_YELLOW}-- INSERT --${PR_DEFAULT}}"
# RPS2=$RPS1
VI_COLOR="${${KEYMAP/vicmd/${PR_RED}}/(main|viins)/${PR_BRIGHT_GREEN}}"
zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


# setup main prompt
PROMPT='%{$(reset_tmux_window)%}${PROMPT_LINE}${PR_GREEN}:${PR_RESET}$(git_super_status)%(!.%B%F{red}%#%f%b.%B${VI_COLOR}$%f%b) ${PR_RESET}'
# secondary prompt
# (( TERMWIDTH = ${COLUMNS} - 2 ))
# PROMPT_ESCAPED=$(echo $PROMPT | sed 's/\$(\w*)//g')
# PROMPT_ESCAPED=${(%e)PROMPT_ESCAPED}
# PROMPT_LENGTH=${#${PROMPT_ESCAPED//\[[^m]##m/}}
# FILL_SPACES=${(l:PROMPT_LENGTH:: :)}

PS2="${PR_BLUE_BRIGHT}> ${PR_RESET}"


