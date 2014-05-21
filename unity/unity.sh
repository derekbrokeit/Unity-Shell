# grab the paths
. $HOME/.path
if [[ -f $HOME/.colors ]] ; then
    . $HOME/.colors
fi
if [[ -f $HOME/.license ]] ; then
    . $HOME/.license
fi

# load unity profiles
unity_source=( ".unity/profile.sh" ".unity/functions.sh" ".unity/alias.sh" ".unity/compilers.sh" )
for file in ${unity_source[@]} ; do
    . $HOME/$file
done

# taking in sources, source them
if [[ ! -z $sources ]] ; then
    for file in ${sources[@]} ; do
        . $HOME/$file
    done
fi

# #I want my umask 0002 if I'm not root
# if [[ $(whoami) = root ]]; then
#   umask 022
# else
#   umask 022
# fi


# --- systems are go
if [[ $TERM != dumb ]] ; then

    # now settup terminal multiplexer (the SSH_CONNECTION was originally meant to block the cellphone)
    if [[ ! -n $DISABLE_TMX && ! -n $TMUX  && ! -n $SSH_CONNECTION ]] ; then
        # This checks if tmux exists, and if it does, runs the startup script tmx
        is_avail tmux && tmx $(hostname -s)  || echo >&2 "tmux did not startup on this machine (is it installed?) ..."
    fi

    # are we connected through SSH?
    if [[ -n $SSH_CONNECTION ]] ; then
        ssh_remote_string="${WHITE_BRIGHT} | ${RED}ssh: ${RED_BRIGHT}$(echo $SSH_CLIENT | awk '{print $1}' )"
    else
        ssh_remote_string=""
    fi

    # Welcome message:
    SIGNIN_DATE=$(date "+%Y年 %m月 %d日 （%a）%H:%M:%S")
    echo "$(printf $BLUE_BRIGHT)$(hostname -s): $(printf $WHITE)${SIGNIN_DATE}${ssh_remote_string}$(printf $NC)"

fi
