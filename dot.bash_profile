#!/bin/bash
#
# This file establishes the system aliases
#

### Setup computer type {{{1
if [[ -f $HOME/.comptype ]] ; then
  COMP_TYPE=$(sed "1q;d" $HOME/.comptype)
else
  echo "*** Please run the setup.sh script in the dot file directory"
  echo "    things may not run smoothly until this is done. Thank you."
fi

# --- load libraries {{{1
# make sure that the svn-rules are setup first
source $HOME/.svn-update-rules

# get all the relevant escape COLORS
source $HOME/.colors

# setup path variables
source $HOME/.profile

# setup user-functions
source $HOME/.functions

# setup aliases
source $HOME/.alias


# --- systems are go {{{1
if [[ $TERM != dumb ]] ; then

  # better input method
  # setup vi input method for readLine
  set -o vi
  # ^p check for partial match in history
  bind -m vi-insert "\C-p":dynamic-complete-history
  # ^n cycle through the list of partial matches
  bind -m vi-insert "\C-n":menu-complete
  # ^l clear screen
  bind -m vi-insert "\C-l":clear-screen
  # fix C-S
  stty stop undef # to unmap ctrl-s

  # now settup terminal multiplexer (the SSH_CONNECTION was originally meant to block the cellphone)
  if [[ ! -n $TMUX ]] && [[ "$COMP_TYPE" != "central" ]] && [[ ! -n $SSH_CONNECTION ]] ; then
    #if [[ ! -n $TMUX ]] && [[ "$COMP_TYPE" != "central" ]] ; then
    # This checks if tmux exists, and if it does, runs the startup script tmx
    {  hash tmux 2>&- && tmx $(hostname -s) ; } || echo >&2 "tmux did not startup on this machine (is it installed?) ..." 
    fi

    # Welcome message:
    SIGNIN_DATE=$(date "+%Y年 %m月 %d日 （%a）%H:%M:%S")
    echo "$(printf $BLUE_BRIGHT)$(hostname -s): $(printf $WHITE)${SIGNIN_DATE}$(printf $NC)"

    # check if port needs update (3 days outdated)
    if [[ "$COMP_TYPE" == "local" ]] ; then
      portupdateneeded 3
    fi

    # check calendar
    # gcalcli agenda

  fi
