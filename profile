#!/bin/bash
#
# This file establishes the system aliases
#

### Universal variables {{{1
export COMP_TYPE=$(cat $HOME/.comptype)
export EDITOR="vim"
export PAGER="less"
export MANPAGER="less"
export GNUTERM="dumb"

# vim temporary directory for swap files
export EDITOR_TMP="${HOME}/.${EDITOR}-tmp"

# tmux files
export TMUX_CONF="$HOME/.tmux.conf"
export TMUX_CONF_NEST="${TMUX_CONF}.nested"
export TMUX_CONF_TMWIN="${TMUX_CONF}.tmwin"
export TMUX_CONF_MINI="${TMUX_CONF}.mini"

# executables
export MD_EXE="md11"

# saving old PS1 value
export PS1_OLD=$PS1
export PS2="\[$BLUE\]> \[$NC\]"

# language variables
export LANG=ja_JP.UTF-8  #C (used to be "C" for English)
export W3MLANG=$LANG

# grep coloring
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

### ls and less color options 
#####################
# Shell variables
## Colors
# less important are the colors ...
# this may only work on OSX
export CLICOLOR=1
export LSCOLORS=CxFxExDxBxegedabagacad
export LS_OPTIONS="--color=auto"

#1. directory
#2. symbolic link
#3. socket
#4. pipe
#5. executable
#6. block special
#7. character special
#8. executable with setuid bit set
#9. executable with setgid bit set
#10.directory writable to others, with sticky bit
#11.directory writable to others, without sticky bit
#
#a  black
#b  red
#c  green
#d  brown
#e  blue
#f  magenta
#c  cyan
#h  light grey
#A  block black, usually shows up as dark grey
#B  bold red
#C  bold green
#D  bold brown, usually shows up as yellow
#E  bold blue
#F  bold magenta
#G  bold cyan
#H  bold light grey; looks like bright white
#x  default foreground or background

#LS_COLORS for Linux
export LS_COLORS="di=01;32:ln=01;35:so=01;34:pi=01;33:ex=01;31:bd=37;46:cd=43;34:"

# colorful man-pages
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

### System specific variables {{{1
if [[ "$COMP_TYPE" == "local" ]] ; then
   ##### MAC
   ## system variables and paths
   export MD_RESEARCH="$HOME/Desktop/Research"
   #export JMOL_HOME="$MD_RESEARCH/jmol"
   export DROPBOX="$HOME/Dropbox"
   
   #  MD sectors
   export MD_SVN="$MD_RESEARCH/svnroot"
   export MD_CODE="$MD_SVN/md-project/trunk"
   export MD_SIMS="$MD_RESEARCH/sims"
   export MD_CG="$MD_SVN/crystal-grower/trunk"
   export MD_INPUT="$MD_CODE/input"
   #export MD_LOGS="$HOME/.mdLogs"
   export MD_HTML="$MD_SVN/html-server-check/trunk"
  
   export LAMMPS_SRC="$MD_RESEARCH/lammps"
   
   # bin files
   export BIN_GE="$MD_SVN/bin-general/trunk"
   export MD_BIN="$MD_SVN/bin-md/trunk"
   
   #  Dropbox sectors
   #export DROP_RESEARCH="$DROPBOX/MD_RESEARCH"
   #export DROP_CODE="$DROP_RESEARCH/md_code"
   #export DROP_SIMS="$DROP_RESEARCH/sims"
   #export DROP_CG="$DROP_RESEARCH/cg"
   #export DROP_BIN="$DROP_RESEARCH/bin"
   #export DROP_INPUT="$DROP_CODE/input"
   #export DROP_LOCAL="$DROP_RESEARCH/local-save"
   ##export DROP_MD_LOGS="$DROPBOX/Public/mdLogs"

   # fortran compiler codes
   export F90_COMP="gfortran"
   export F90_FLAGS="-ffixed-line-length-none" 

   # add path to MD Shell scripts
   export PATH="/opt/local/libexec/gnubin:$PATH"
    ## Mac Ports
    # MacPorts Installer addition on 2011-07-26_at_17:29:56: adding an appropriate PATH variable for use with MacPorts.
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    # Finished adapting your PATH environment variable for use with MacPorts.
   export PATH="$HOME/bin:$PATH"
   export PATH="$BIN_GE:$PATH"
   export PATH="$MD_BIN:$PATH"
   
   # Application user variables
   export MATHEMATICA_USERBASE="$MD_SVN/mathematica/base"
   export MATLAB="$DROPBOX/matlab"
   
   # system bash profile
   export BASH_PROFILE="$HOME/.bash_profile"
   
   # keep log files together
   export LOGS_DIR="$DROPBOX/serverLogs"

   # MacPorts Bash shell command completion
   if [[ -f /opt/local/etc/bash_completion ]]; then       
     . /opt/local/etc/bash_completion              
   fi                                                
  
   # the prompt line
   if [[ "$PS1" == '\h:\W \u\$ ' ]] ; then 
     export PS1="\[$YELLOW_BRIGHT\]\h \[$GREEN\]"'$(__git_ps1 "(%s) ")'"\[$YELLOW_BRIGHT\]\$ \[$NC\]"
   fi
   # note about PS1, use \[\] brackets around variables that should have no length ie. color

   # this load libraries (specifically the following is a matlab path
   #export LD_LIBRARY_PATH=${HOME}/local/lib/:${LD_LIBRARY_PATH}

### Remote Server variables {{{1
elif [[ "$COMP_TYPE" == "central" ]] || [[ "$COMP_TYPE" == "remote" ]] ; then
   ##### Linux Servers
   # important folders
   export MD_SVN="$HOME"
   export MD_CODE="$MD_SVN/md-project"
   export MD_CG="$MD_SVN/crystal-grower"
   export MD_INPUT="$MD_CODE/input"
   export MD_SIMS="$HOME/sims"
   export MD_BIN="$MD_SVN/bin-md"
   export PATH="$MD_BIN:$PATH"

   export MD_EXE="md11"

   export LAMMPS_SRC="$MD_SVN/lammps"

   # local profile
   export BASH_PROFILE="$HOME/.bashrc"

   # the prompt line
   if [[ "x$(which git 2> /dev/null)" != "x" ]] ; then
     export PS1="\[$YELLOW_BRIGHT\]${HOSTNAME:0:1} \[$GREEN\]"'$(__git_ps1 "(%s) ")'"\[$YELLOW_BRIGHT\]> \[$NC\]"
   else
     export PS1="\[$YELLOW_BRIGHT\]${HOSTNAME:0:1} > \[$NC\]"
   fi
   
   # in the even that packages must be installed on remote server
   export CONF_PREF="-prefix=$HOME/local"
   export LD_LIBRARY_PATH="${HOME}/local/lib/:${HOME}/local/lib64/:${LD_LIBRARY_PATH}"
   export PATH="$HOME/local/bin:$PATH"

   # LAPACK libraries
   export BLAS_LIBS="$HOME/local/lib/libblas.a"
   export LAPACK_LIBS="$HOME/local/lib/liblapack.a"

   ## setup remote-host specific variables
   case $HOSTNAME in 
      [c]* )
         export filesvn="file:///home/derekt/svnroot"
         export PS1="\[$YELLOW_BRIGHT\]${HOSTNAME:0:1} > \[$NC\]"
         if [[ "$HOSTNAME" == "cello3" ]] ; then
           export PS1="\[$YELLOW_BRIGHT\]3 > \[$NC\]"
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

