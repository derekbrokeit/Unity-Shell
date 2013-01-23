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
alias -g LP='| pygmentize -g -O style=monokai | less'
alias -g P='LP'
alias -g NE='2> /dev/null'
alias -g NA='&> /dev/null'
alias -g S='| sort'
alias -g TL='| tail -20'
alias -g T='| tail'
alias -g H='| head'
alias -g HL='|& head -30'
alias -g CP='| reattach-to-user-namespace pbcopy'

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

