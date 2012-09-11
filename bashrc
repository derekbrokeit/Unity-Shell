#!/bin/bash
# source the .bash_profile file instead
# if [[ $HOSTNAME == h* && $(cat ~/.comptype) != "local" && -f $HOME/local/bin/zsh ]] ; then
#   # load alternative shell
#   # read -p "load zsh? " yn
#   yn="y"
#   case $yn in
#     [yY]* ) 
#       # this fixes a specific error caused by running the zsh
#       # the error:
#       #     newuser:6: zsh-newuser-install: function definition file not found
#       #     /etc/zsh/zshrc:50: compinit: function definition file not found
#       unset FPATH

#       export SHELL=$HOME/local/bin/zsh
#       # open zsh as the login shell!
#       exec $SHELL -l
#       ;;
#     * )
#       echo 'no problem with $SHELL!'
#       ;;
#   esac
# fi
source $HOME/.bash/bash_profile

[[ -s ~/.autojump/etc/profile.d/autojump.bash ]] && source ~/.autojump/etc/profile.d/autojump.bash
