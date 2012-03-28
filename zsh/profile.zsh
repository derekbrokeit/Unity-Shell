#
# This file establishes the system aliases 
#
### Universal variables {{{1
export COMP_TYPE=$(cat $HOME/.comptype)

# export EDITOR="vim"
export EDITOR="$(which tmvim)"
export PAGER="$(which less)"
export BROWSER="$(which lynx)"
# export PAGER="vimpager"
export MANPAGER="$PAGER"
export GNUTERM="dumb"
export DISPLAY=:0.0

# vim temporary directory for swap files
export EDITOR_TMP="${HOME}/.${EDITOR}-tmp"

# tmux files
export TMUX_CONF="$HOME/.tmux.conf"
export TMUX_CONF_NEST="${TMUX_CONF}.nested"
export TMUX_CONF_TMWIN="${TMUX_CONF}.tmwin"
export TMUX_CONF_MINI="${TMUX_CONF}.mini"

# executables
export MD_EXE="md11"

# python startup file
export PYTHONSTARTUP=$HOME/.pythonrc.py

# language variables
export LANG=ja_JP.UTF-8  #C (used to be "C" for English)
export W3MLANG=$LANG



### System specific variables {{{1
if [[ "$COMP_TYPE" == "local" ]] ; then
  ##### MAC

  #export JMOL_HOME="$MD_RESEARCH/jmol"
  export DROPBOX="$HOME/Dropbox"
  export LAMMPS_SRC="$HOME/dev/lammps"

  # fortran compiler codes
  export F90_COMP="gfortran"
  export F90_FLAGS="-ffixed-line-length-none" 

  # Application user variables
  # export MATHEMATICA_USERBASE="$MD_SVN/mathematica/base"
  export MATLAB="$DROPBOX/matlab"

  # keep log files together
  export LOGS_DIR="$DROPBOX/serverLogs"

  ### Remote Server variables {{{1
elif [[ "$COMP_TYPE" == "central" ]] || [[ "$COMP_TYPE" == "remote" ]] ; then

  export MD_EXE="md11"

  export LAMMPS_SRC="$HOME/dev/lammps"

  # in the even that packages must be installed on remote server
  export CONF_PREF="-prefix=$HOME/local"

  ## setup remote-host specific variables
  case $HOSTNAME in 
    [c]* )
      # there is no compiler
      export F90_COMP=""
      export F90_FLAGS=""
      ;;
    [h]*)
      export F90_COMP="ifort"
      export F90_FLAGS=""
      ;;
    [tm]*)
      export F90_COMP="pgf90"
      export F90_FLAGS=""

      ;;
    *)
      echo "*** This Linux computer is not yet setup for this $SHELL profile"
      echo "*** Please update the .profile files for this :)"
      export F90_COMP=""
      export F90_FLAGS=""
      #IP_ME="$(hostname -i)"
      ;;
  esac

  ### Not yet supported machine {{{1
else
  echo "*** This computer is not yet setup for this $SHELL profile"
  echo "*** Please update the $SHELL profile files for this :)"
  echo "*** compTypeName = \"$(COMP_TYPE)\""
  echo "*** hostname     = \"$HOSTNAME\""
  echo ""

  # setup some essential variables
  export F90_COMP=""
  export F90_FLAGS=""
  IP_ME="$(hostname -i)"


fi

### Cleaning up {{{1
#### Clean up
# Make sure that the md.idLog file exists
#if [[ "x${PBS_O_HOST}" == "x" ]] ; then
#mkdir -p $MD_LOGS
#touch $MD_LOGS/$HOSTNAME.md.idLog
#fi

# Make the compiler info publicly accessible
echo $F90_COMP > $HOME/.f90compiler
echo $F90_FLAGS > $HOME/.f90flags

# also, should cover F77
export F90=$F90_COMP
export F77=$F90

# --- GPG agent initialization
# # setup gpg (this is the old way)
# if [[ "x$(which gpg2)" != "x" ]] ; then
#   export GPG_TTY=$(tty) 
#   eval $(gpg-agent --daemon) 
# fi

# the following is a better way from Oh-my-zsh
local GPG_ENV=$HOME/.gnupg/gpg-agent.env

function start_agent {
  /usr/bin/env gpg-agent --daemon --enable-ssh-support --write-env-file ${GPG_ENV} > /dev/null
  chmod 600 ${GPG_ENV}
  . ${GPG_ENV} > /dev/null
}

# Source GPG agent settings, if applicable
if [ -f "${GPG_ENV}" ]; then
  . ${GPG_ENV} > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep gpg-agent > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

export GPG_AGENT_INFO
export SSH_AUTH_SOCK
export SSH_AGENT_PID

export GPG_TTY=$(tty)
