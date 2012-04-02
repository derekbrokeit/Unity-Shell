if [[ $COMP_TYPE == "local" ]] ; then
  ## Mac Ports
  # MacPorts Installer addition on 2011-07-26_at_17:29:56: adding an appropriate PATH variable for use with MacPorts.
  # echo "PATH: $PATH"
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  # This makes GNU binaries override some apple binaries (ie. ls, grep, etc.)
  export PATH="/opt/local/libexec/gnubin:$PATH"

  # # Finished adapting your PATH environment variable for use with MacPorts.
  # export PATH="$HOME/bin:$PATH"
  # export PATH="$BIN_GE:$PATH"
  # export PATH="$MD_BIN:$PATH"
else
  export LD_LIBRARY_PATH="${HOME}/local/lib/:${HOME}/local/lib64/:${LD_LIBRARY_PATH}"
  export PATH="$HOME/local/bin:$PATH"
fi

# Save the path for later
export PATH_ORIG="$PATH"

# --- regenpath: generate PATH--- {{{2
function regenpath(){
if [[ -n $PATH_ORIG ]] ; then
  export PATH=$PATH_ORIG
fi
SEARCH_PATH="$HOME/bin $HOME/dev"
if [[ $COMP_TYPE == "remote" ]] ; then
  SEARCH_PATH="$HOME/local $SEARCH_PATH"
fi
for dir in $(find $SEARCH_PATH -type d  -regex ".*\/bin" )
do
  # strip the trailing colon (not actually necessary)
  if [[ $PATH != *${dir}* ]] ; then
    # only insert the directory if it is unique
    # user defined functions take precedence over system functions
    export PATH="${dir}:$PATH"
  fi
done
}
regenpath

function regenpathpy(){
PYTHONPATH=
for dir in $(find $HOME/bin $HOME/dev -type d  -regex ".*\/py\(\w\|-\w\|\w*\/src\|-\w*\/src\)*")
do
  if [[ $PYTHONPATH != *${dir}* ]] ; then
    # only insert the directory if it is unique
    # the order is irrelevant
    export PYTHONPATH="$PYTHONPATH:${dir}"
  fi
done
}
regenpathpy

