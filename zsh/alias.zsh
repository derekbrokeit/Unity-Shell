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
compdef tmvim=vim
compdef vi=vim

# get rid of dyld libraries for system functions
alias ps="env -u DYLD_INSERT_LIBRARIES ps"
alias rcp="env -u DYLD_INSERT_LIBRARIES rcp"
alias at="env -u DYLD_INSERT_LIBRARIES at"
alias atq="env -u DYLD_INSERT_LIBRARIES atq"
alias atrm="env -u DYLD_INSERT_LIBRARIES atrm"
alias batch="env -u DYLD_INSERT_LIBRARIES batch"
alias crontab="env -u DYLD_INSERT_LIBRARIES crontab"
alias ipcs="env -u DYLD_INSERT_LIBRARIES ipcs"
alias lockfile="env -u DYLD_INSERT_LIBRARIES lockfile"
alias login="env -u DYLD_INSERT_LIBRARIES login"
alias newgrp="env -u DYLD_INSERT_LIBRARIES newgrp"
alias procmail="env -u DYLD_INSERT_LIBRARIES procmail"
alias quota="env -u DYLD_INSERT_LIBRARIES quota"
alias rlogin="env -u DYLD_INSERT_LIBRARIES rlogin"
alias rsh="env -u DYLD_INSERT_LIBRARIES rsh"
alias su="env -u DYLD_INSERT_LIBRARIES su"
alias sudo="env -u DYLD_INSERT_LIBRARIES sudo"
alias top="env -u DYLD_INSERT_LIBRARIES top"
alias wall="env -u DYLD_INSERT_LIBRARIES wall"
alias write="env -u DYLD_INSERT_LIBRARIES write"
alias postdrop="env -u DYLD_INSERT_LIBRARIES postdrop"
alias postqueue="env -u DYLD_INSERT_LIBRARIES postqueue"
alias scselect="env -u DYLD_INSERT_LIBRARIES scselect"
alias traceroute="env -u DYLD_INSERT_LIBRARIES traceroute"
alias traceroute6="env -u DYLD_INSERT_LIBRARIES traceroute6"
