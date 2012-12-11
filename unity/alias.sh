# movement
alias -- -='cd -'
alias ..="cd .."
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

# coreutils
# attempt to realias all coreutils
if [[ -x $(which gls 2> /dev/null) ]] ; then
    # coreutils are installed
    alias ls='gls --color=auto'
    alias dir='gdir --color=auto'
    alias vdir='gvdir --color=auto'
    alias dircolors="gdircolors"
else
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi
if [[ -x $(which ssed 2> /dev/null) ]] ; then
    alias sed="ssed"
fi
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# list operations
alias ll='ls -lah'
alias sl='ls -lah'
alias l='ls -la'
alias lsd='ls -d *(/)'
alias lsdd='ls -d **/'

# editors
alias   v="$EDITOR"
alias  vi="$EDITOR"

#  setup easy to use variabls
alias rmi='rm -i '
alias cpi='cp -i '
alias grepi='grep -i '
alias tarzip='tar -cvzf '
alias untarzip='tar -xvzf '
alias fileSize='du -h '


if [[ ! -z $(which hili 2> /dev/null) ]] ; then
    alias make="hili make"
    if [[ $COMP_TYPE == remote ]] ; then
        alias config="hili ./configure --prefix=$HOME/local"
    else
        alias config="hili ./configure"
    fi
fi


# handy command to detach tmux but keep the shell running (kind-of)
if [[ -n $TMUX ]] ; then
    alias detach="tmux detach"
fi

if [[ ! -z $(which ipython 2> /dev/null) ]] ; then
    alias ipy="ipython "
    alias ipq="ipython qtconsole --ConsoleWidget.font_family='Anonymous Pro' --ConsoleWidget.font_size=12 --style=native --pylab=inline"
else
    alias ipy="python"
fi
alias pydserve="pydoc -p 9999 "

# pizza py
alias pizza="python ~/dev/py-pizza/src/pizza.py"

# syntax highlighter cat
alias pcat="pygmentize -g"
pless() {
    pygmentize -g "$@" | less -R
}

# --- git specific aliases
# personal git aliases
alias glu='git ls-files --other --exclude-standard'
alias glm='git ls-files --modified'
alias gir='gitrack -i'

# open files in vim
alias vgu='vim -p $(git ls-files --other --exclude-standard)'
alias vgm='vim -p $(git ls-files --modified --exclude-standard)'
alias mgm='ms $(git ls-files --modified --exclude-standard)'

# molecular viewer
alias pymol="pymol -M"

# download webpage and all children
alias wwwdown='wget --wait=20 \
    --radnom-wait \
    --limit-rate=20K \
    --no-parent \
    --recursive \
    --page-requisites \
    --html-extension \
    --convert-links \
    '

# the following is originally from:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git/git.plugin.zsh
# Aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gco='git checkout'
alias gcm='git checkout master'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias glg='git log --stat --max-count=5'
alias glgg='git log --graph --max-count=5'
alias gss='git status -s'
alias ga='git add'
alias gm='git merge'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'

# --- for the lulz
# history lesson
alias histlesson="cat /usr/share/calendar/calendar.history"

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
    alias tree='tree -C'
    if [[ "$(hostname -s)" == k* ]] ; then
        alias ircw="tmux new-window -n irssi -t 8 'irc'"
    else
        alias ircw="tmux neww -n irssi -t 8 \"tssh k -t 'source $HOME/.path ; irc'\""
        alias irc="tssh k -t 'source $HOME/.path ; irc'"
    fi

    # lock the pc
    remotelock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

    # lolz (I got these from some other github directory, but their fun)
    alias stfu="osascript -e 'set volume output muted true'"
    alias pumpitup="osascript -e 'set volume 10'"
    alias hax="terminal-notify -t 'Activity Monitor: System error' -m 'WTF IS GOING ON?!'"
    # the very important nyan cat alias
    if [[ -x `which nc` ]]; then
        alias nyan='nc -v miku.acm.uiuc.edu 23' # nyan cat
    fi

    ### Remote server aliases {{{1
elif [[ "$COMP_TYPE" == "central" || "$COMP_TYPE" == "remote" ]] ; then
    #### linux
    # PBS statistics
    alias qme='qstat -u $USER'
fi

