#!/bin/sh

## make sure that the script is being called from the right directory
pushd . > /dev/null
cd ${0%/*}

# setup the computer type and rc file location
if [[ ! -f $HOME/.comptype ]] ; then
  echo    '## -- setting up .comptype -- ## '
  while [[ 1 ]] ; do
    read -p 'COMP_TYPE =? (l,c,r,?) ' COMP_TYPE
    case $COMP_TYPE in
      [lL]*)
        COMP_TYPE="local"
        break
        ;;
      [cC]*)
        COMP_TYPE="central"
        break
        ;;
      [rR]*)
        COMP_TYPE="remote"
        break
        ;;
      *)
        echo "*** local, central, or remote computer?"
        echo "     - local: personal computer accessed directly by the user"
        echo "     - central: a central server used to pass on to remote servers"
        echo "     - remote: a remote server accessed only through ssh"
        ;;
    esac
  done
  echo -e "${COMP_TYPE}" > $HOME/.comptype
fi
if [[ $COMP_TYPE == "local" ]] && [[ -d $HOME/Dropbox ]] ; then
  LOGS_DIR=$HOME/Dropbox/serverLogs
  mkdir -p $LOGS_DIR
else
  FAIL_LOGS_DIR=0
fi

# check shell
chshfile=$HOME/.chsh
if [[ ! -f $chshfile ]] ; then
  echo "## -- setting up shell -- ##"
  while [[ 1 ]] ; do
    read -p 'SHELL =? ' shell
    found=0
    for file in $(find . -maxdepth 1 ) ; do
      if [[ $file == "./$shell"* ]] ; then
        found=1
        file=${file#./}
        rm $HOME/.$file &> /dev/null
        ln -s $PWD/$file $HOME/.$file
        echo "ln -s $file \$HOME/.$file"
      fi
    done
    if [[ $found -eq 1 ]] ; then
      echo "- changing shell to '$shell'"
      { chsh -s /bin/$shell && echo '! Success' ; touch $chshfile ; } || echo '*** Error changing shells '
      break
    fi
  done

fi


## setup symbolic links
i=0
altdir="misc"
for file in $(find $altdir/ -maxdepth 1 | sed "s/$altdir\///g");do
  # if [[ ! -L "$HOME/.$file" ]] ; then

  if [[ $i -eq 0 ]] ; then
    echo "## -- setting up symbolic links -- ##"
    i=1
  fi

  rm $HOME/.$file &> /dev/null
  ln -s ${PWD}/${altdir}/${file} ${HOME}/.${file}
  echo "ln -s ${altdir}/$file \$HOME/.$file"

  #else
  #rm $HOME/.$file
  # fi
done

## setup server connection file
if [[ "x$FAIL_LOGS_DIR" == "x" ]] && [[ ! -f $LOGS_DIR/serverconn ]] ; then
  ./serversetup.sh
fi

## return to the original directory
popd > /dev/null

echo "## -- Please restart your terminal for changes to take effect"
