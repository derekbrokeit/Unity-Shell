
### Setup computer type
if [[ -f $HOME/.comptype ]] ; then
    export COMP_TYPE=$(sed "1q;d" $HOME/.comptype)
else
    echo "*** Please run the setup.sh script in the dot file directory"
    echo "    things may not run smoothly until this is done. Thank you."
fi

# grab the paths
. $HOME/.path
. $HOME/.colors

# load unity profiles
unity_source=( ".unity/profile.sh" ".unity/functions.sh" ".unity/alias.sh" )
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
    if [[ ! -n $DISABLE_TMX && ! -n $TMUX  && "$COMP_TYPE" != "central"  &&  ! -n $SSH_CONNECTION ]] ; then
        #if [[ ! -n $TMUX ]] && [[ "$COMP_TYPE" != "central" ]] ; then
        # This checks if tmux exists, and if it does, runs the startup script tmx
        hash tmux 2>&- && tmx $(hostname -s)  || echo >&2 "tmux did not startup on this machine (is it installed?) ..."
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

    # check if port needs update (3 days outdated)
    if [[ "$COMP_TYPE" == "local" ]] ; then
        pup-needed 3
    fi

fi
