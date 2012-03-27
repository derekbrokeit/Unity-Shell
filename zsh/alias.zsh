alias ls='ls --color=auto'
# standard
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias  vi='$EDITOR'
alias vim='$EDITOR'

alias -- -='cd -'
alias ..="cd .."
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

# suffix
alias -s tex='$EDITOR'
alias -s txt='$EDITOR'
alias -s html='$BROWSER'
alias -s org='$BROWSER'
alias -s com='$BROWSER'

# global
alias -g G='| egrep'
alias -g NE='2> /dev/null'
alias -g NA='&> /dev/null'
alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g H='| head'
alias -g HL='|& head -20'

# list operations
alias ll='ls -lah'
alias sl='ls -lah'
alias l='ls -la'
alias ld='ls -d *(/)'
alias ldd='ls -d **/'

#  setup easy to use variabls
alias rmi='rm -i '
alias cpi='cp -i '
alias grepi='grep -i '
alias tarzip='tar -cvzf '
alias untarzip='tar -xvzf '
alias fileSize='du -h '

# hilight stderr in make and configure scripts
if  which hili NA  ; then 
  alias make="hili make"
  if [[ $COMP_TYPE == "remote" ]] ; then
    alias config="hili ./configure --prefix=$HOME/local)"
  fi
fi

# handy command to detach tmux but keep the shell running (kind-of)
if [[ -n $TMUX ]] ; then
  alias detach="tmux detach" 
fi

if [[ -n ipython ]] ; then
  alias ipyc="ipython console"
  alias ipy="ipython "
else
  alias ipy="python"
fi

# pizza py
alias pizza="python ~/dev/py-pizza/src/pizza.py"

# remap mutt to tmuxified mutt
alias mutt=tmmutt
# syntax highlighter cat
alias pcat="pygmentize -g"
function pless() {
pygmentize -g "$@" | less -R
}

### System specific aliases {{{1
if [[ "$COMP_TYPE" == "local" ]] ; then

  # proxy server connection for getting articles
  alias proxyssh='tssh -P'

  # system functions
  # these reference shell scripts that I have created
  alias batteryinfo='pmset -g'
  alias suwifi='sudo tempwifi'

  # calendar stuff
  alias gcalw='gcalcli calw'  
  alias gcalm='gcalcli calm'
  alias gcala='gcalcli --details agenda'
  alias gcaladd='google calendar add '

  # Other
  #alias simsummary='open http://dl.dropbox.com/u/7645999/mdLogs/index.html'
  alias matlab='/Applications/MATLAB_SV74/bin/matlab -nojvm -nosplash -nodesktop'
  alias octave='hili octave -q'
  alias dterm='open /Applications/DTerm.app'
  alias t='todotxt'
  alias tree='tree -C'
  alias tmo='tmoct'
  alias tmv='tmvim'
  if [[ ${HOSTNAME%.*} == k* ]] ; then
    alias ircw="tmux new-window -n 'irssi' 'irc'"
  else
    alias ircw="tssh k -t 'irc'"
  fi

  # maybe useful for git
  alias undopush="git push -f origin HEAD^:master"

  # for the lolz (I got these from some other github directory, but their great)
  alias stfu="osascript -e 'set volume output muted true'"
  alias pumpitup="osascript -e 'set volume 10'"
  alias hax="growlnotify -a 'Activity Monitor' 'System error' -m 'WTF IS GOING ON?!'"

  ### Remote server aliases {{{1
elif [[ "$COMP_TYPE" == "central" ]] || [[ "$COMP_TYPE" == "remote" ]] ; then
  #### linux
  # PBS statistics
  alias qme='qstat -u $USER'

fi

