# Inside a tmux session {{{2
if [[ -n $TMUX ]] ; then
    # changeTitle: setting the terminal title  {{{3
    changeTitle() {
        # check the input
        if [[ "$1" == "-default" ]] ; then
            # default 
            export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%.*}: $(shortdir --nohome)\007"'
        elif [[ "$1" == "-temp" ]] ; then
            # default 
            shift 1
            printf "\033]2;$@\033\\"
        else
            export PROMPT_COMMAND='echo -ne "\033]0;'"${1}"'\007"'
        fi
    }
    # during profile resourcing, set title as default
    changeTitle -default

    # ct: short-term title change from within funcs {{{3
    ct() {
        printf "\033]2;$@\033\\"
    }

    # wintitle: setting the tmux window title {{{3
    # previously setTitle
    wintitle() { 
        # check the input
        if [[ "$1" == "-default" ]] ; then
            # default 
            printf "\033k$(hostname -s)\033\\" 
        else
            printf "\033k$1\033\\" 
        fi
    }
fi
