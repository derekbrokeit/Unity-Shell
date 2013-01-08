# suffix
alias -s tex=$EDITOR
alias -s txt=$EDITOR
alias -s html='$BROWSER'
alias -s org='$BROWSER'
alias -s com='$BROWSER'

# web pages
alias google.com='$BROWSER google.com/ncr'
alias googlecom='$BROWSER google.com/ncr'
alias web="$HOME/.startup.html"
alias w3m="w3m -O UTF-8"

# global
alias -g G='| egrep'
alias -g L='| less'
alias -g LP='| pygmentize -g | less'
alias -g NE='2> /dev/null'
alias -g NA='&> /dev/null'
alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g H='| head'
alias -g HL='|& head -20'

# autocomplete git aliases
compdef g=git
compdef _git gst=git-status
compdef _git gl=git-pull
compdef _git gup=git-fetch
compdef _git gp=git-push
compdef _git gdv=git-diff
compdef _git gc=git-commit
compdef _git gca=git-commit
compdef _git gco=git-checkout
compdef _git gb=git-branch
compdef _git gba=git-branch
compdef gcount=git
compdef _git gcp=git-cherry-pick
compdef _git glg=git-log
compdef _git glgg=git-log
compdef _git gss=git-status
compdef _git ga=git-add
compdef _git gm=git-merge

# autocomplete vim
compdef v=vim
compdef vi=vim

# get rid of dyld libraries for system functions
# check if the 'u' option is even available, then proceed

if env -u DYLD_INSERT_LIBRARIES > /dev/null 2>&1 ; then
    # get the right 'env' prefering 'genv'
    is_avail genv && local ENV=genv || local ENV=env
    ENV="$ENV -u DYLD_INSERT_LIBRARIES"

    alias ps="$ENV ps"
    alias rcp="$ENV rcp"
    alias at="$ENV at"
    alias atq="$ENV atq"
    alias atrm="$ENV atrm"
    alias batch="$ENV batch"
    alias crontab="$ENV crontab"
    alias ipcs="$ENV ipcs"
    alias lockfile="$ENV lockfile"
    alias login="$ENV login"
    alias newgrp="$ENV newgrp"
    alias procmail="$ENV procmail"
    alias quota="$ENV quota"
    alias rlogin="$ENV rlogin"
    alias rsh="$ENV rsh"
    alias su="$ENV su"
    alias sudo="$ENV sudo"
    alias top="$ENV top"
    alias wall="$ENV wall"
    alias write="$ENV write"
    alias postdrop="$ENV postdrop"
    alias postqueue="$ENV postqueue"
    alias scselect="$ENV scselect"
    alias traceroute="$ENV traceroute"
    alias traceroute6="$ENV traceroute6"
    alias qmake="$ENV qmake"
    alias brew="$ENV brew"

    unset ENV
fi
