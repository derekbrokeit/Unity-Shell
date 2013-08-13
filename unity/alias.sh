# movement
alias -- -='cd -'
alias ..="cd .."
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

# coreutils
# attempt to realias all coreutils
if is_avail gls ; then
    # coreutils are installed
    alias ls='gls --color=auto'
    alias dir='gdir --color=auto'
    alias vdir='gvdir --color=auto'
    alias dircolors="gdircolors"
    alias find="gfind"
else
    if ls --color -d . > /dev/null 2>&1  ; then
        # GNU ls
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'
    fi
fi
if is_avail ssed ; then
    alias sed="ssed"
fi
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# htop
if is_avail htop ; then
    alias htop="sudo htop"
fi

# list operations
alias ll='ls -lah'
alias sl='ls -lah'
alias l='ls -la'
alias lsd='ls -d *(/)'
alias lsdd='ls -d **/'

# editors
alias   v="$EDITOR"
alias  vi="$EDITOR"
if os_is_osx; then
    alias mvim="reattach-to-user-namespace mvim"
fi

#  setup easy to use variabls
alias rmi='rm -i '
alias cpi='cp -i '
alias grepi='grep -i '
alias tarz='tar cvzf '
alias utarz='tar xvf '
alias fsize='du -h '

# handy command to detach tmux but keep the shell running (kind-of)
if [[ -n $TMUX ]] ; then
    alias detach="tmux detach"
fi

alias ipy="ipython "
alias ipq="ipython qtconsole --ConsoleWidget.font_family='Anonymous Pro' --ConsoleWidget.font_size=12 --style=native --pylab=inline"

alias pydserve="pydoc -p 9999 "

# syntax highlighter cat
alias pcat="pygmentize -g"
pless() {
    pygmentize -g "$@" | less -R
}

# --- git specific aliases
# personal git aliases
alias glu='git ls-files --other --exclude-standard'
alias glm='git ls-files --modified'
alias cdbase='cd $(git rev-parse --show-toplevel)'

# open files in vim
alias vgu='vim -p $(git ls-files --other --exclude-standard)'
alias vgm='vim -p $(git ls-files --modified --exclude-standard)'
alias mgm='reattach-to-user-namespace mvim -p $(git ls-files --modified --exclude-standard)'
alias mgu='reattach-to-user-namespace mvim -p $(git ls-files --other --exclude-standard)'

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

# proxy server connection for getting articles
alias proxyssh='tssh -P'

alias tree='tree -C'

if is_avail qstat ; then
    alias qme='qstat -u $USER'
fi

### System specific aliases {{{1
if os_is_osx ; then
    alias battery='pmset -g'

    # lock the pc remotely
    remotelock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
fi
