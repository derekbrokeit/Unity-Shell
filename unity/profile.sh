
### Universal variables {{{1
export COMP_TYPE=$(cat $HOME/.comptype)

#export EDITOR="$HOME/bin/tmvim"
export EDITOR="vim"
export PAGER="less"
export BROWSER="v3m"

# export PAGER="vimpager"
export MANPAGER="$PAGER"
export GNUTERM="dumb"
export VMAIL_HTML_PART_READER="w3m -dump -o display_link_number=1 "
export VMAIL_VIM="mvim"

# vim temporary directory for swap files
export EDITOR_TMP="${HOME}/.${EDITOR}-tmp"

# tmux files
export TMUX_CONF="$HOME/.tmux.conf"
export TMUX_CONF_NEST="${TMUX_CONF}.nested"
export TMUX_CONF_TMWIN="${TMUX_CONF}.tmwin"
export TMUX_CONF_MINI="${TMUX_CONF}.mini"

# virtualenvwrapper
if [[ -x /opt/local/bin/python ]] ; then
    export VIRTUALENVWRAPPER_PYTHON=/opt/local/bin/python
fi

# python startup file
export PYTHONSTARTUP=$HOME/.pythonrc.py

# language variables
export LANG="$(locale -a | egrep 'en_US.*(utf|UTF)')"
export LC_ALL=$LANG

# grep coloring
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# colorful man-pages
# Less Colors for Man Pages
export LESS="-R"
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# lammps documentation files
if [[ -d $HOME/dev/lammps/doc ]] ; then
    export LAMMPS_DOCS=$HOME/dev/lammps/doc
fi

# ls color options
export LS_OPTIONS="--color=auto"

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

  # sshfs folders reside in this directory
  export SSHFS_DIR="$HOME/sshfs"

  # the save directory for lynx
  export LYNX_SAVE_SPACE=$HOME/lynx-download
  export LYNX_CFG=$HOME/.lynx.cfg
  if [[ ! -d $LYNX_SAVE_SPACE ]] ; then
    mkdir $LYNX_SAVE_SPACE
  fi

  export PS1="\[$(printf $YELLOW_BRIGHT)\]$(hostname -s)\[$(printf $BLUE_BRIGHT)\]:\[$(printf $GREEN_BRIGHT)\]\$ \[$(printf $NC)\]"

  ### Remote Server variables {{{1
elif [[ "$COMP_TYPE" == "central" ]] || [[ "$COMP_TYPE" == "remote" ]] ; then

  # make sure that git doesn't throw errors on https:// sites
  export GIT_SSL_NO_VERIFY=true

  # local profile
  #export BASH_PROFILE="$HOME/.bashrc"

  # the prompt line
  export PS1="\[$(printf $YELLOW_BRIGHT)\]${HOSTNAME:0:1} > \[$(printf $NC)\]"

  # in the even that packages must be installed on remote server
  export CONF_PREF="-prefix=$HOME/local"

  # LAPACK libraries
  export BLAS_LIBS="$HOME/local/lib/libblas.a"
  export LAPACK_LIBS="$HOME/local/lib/liblapack.a"

  # keep log files together
  export LOGS_DIR="$HOME/.serverLogs"
  if [[ ! -d $LOGS_DIR ]] ; then
    mkdir -p $LOGS_DIR
    chmod 700 $LOGS_DIR
  fi

  ## setup remote-host specific variables
  case $HOSTNAME in
    [c]* )
      export filesvn="file:///home/derekt/svnroot"
      export PS1="\[$(printf $YELLOW_BRIGHT)\]${HOSTNAME:0:1} > \[$(printf $NC)\]"
      if [[ "$HOSTNAME" == *3  ]] ; then
        # cut the final number off of the name and make that the prompt
        export PS1="\[$(printf $YELLOW_BRIGHT)\]${HOSTNAME#${HOSTNAME%?}} > \[$(printf $NC)\]"
      fi

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

      if [[ "$HOSTNAME" == "mezzo" ]] ; then
        export IP_ME="$IP_MEZZO"
      fi
      ;;
    *)
      echo "*** This Linux computer is not yet setup for this bash profile"
      echo "*** Please update the .profile files for this :)"
      export F90_COMP=""
      export F90_FLAGS=""
      #IP_ME="$(hostname -i)"
      ;;
  esac

  ### Not yet supported machine {{{1
else
  echo "*** This computer is not yet setup for this bash profile"
  echo "*** Please update the bash profile files for this :)"
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

