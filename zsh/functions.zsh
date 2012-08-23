#!/bin/bash
#
# This file establishes the system functions
# first Universal functions, followed by system-specific functions
#


# Universal functions {{{1o
# pid-with-children: list a process with all its children  {{{2o
function pid-with-children() { 
# grab a list of the process id and all children
if [ "$1" == "--number" ] && [ "x$2" != "x" ] ; then
  ps -ef | grep "$2" | awk '!/grep/' | awk '{print $2}'
elif [ "$1" == "--directory" ] && [ "x$2" != "x" ] ; then
  ps -ef | grep "$2" | awk '!/grep/' | awk '{print $NF}'
elif [ "x$1" != "x" ] ; then
  ps -ef | grep "$1" | awk '!/grep/' 
else
  echo "pid-with-children, Usage: pid-with-children [--number,--directory,''] {\$pid}"
fi
}

# kill-with-children: kill a process and all its children  {{{3
function kill-with-children() { 

# loop through the process list and kill each pid
if [ "x$1" != "x" ] ; then
  iter=1
  for pid in $(pid-with-children --number $1) ; do
    echo "kill: " $pid $(ps -ef $pid | grep "$pid" | awk '{for(i=8;i<=NF;i++){print $i}}')
    kill $pid
    let iter++
  done
else
  echo "kill-with-children, Usage: kill-with-children {\$pid}"
fi
}

# vs, ms, viw: vim functions  {{{2
function vs () {
if [[ "x$@" != "x" ]] ; then
    sname=$1
    ed="$EDITOR"
    shift 1
else
    if [[ $(uname) == "Darwin" ]] ; then
        sname="mvim"
    else
        sname="gvim"
    fi
    ed="$sname"
fi
$ed -p --servername $sname --remote-tab $@
}

function ms {
if [[ "x$@" != "x" ]] ; then
    opts="--remote-tab-silent"
else
    opts=""
fi
mvim --servername mvim $opts $@
}


function viw {
local location=$(which "$1")
if [[ -f "$location" ]]; then
    $EDITOR "$location"
else
    echo "$location isn't a file."
fi
}


# convertTimeStamp: convert a time stamp from seconds-from-epoch to readable format  {{{2
function convertTimeStamp() { 
# converts from seconds-from-epoch to readable format of date-timestamp
if [ "$(uname)" == "Darwin" ] ; then
  date -r $1
else
  date -d @$1
fi
}

# fileSize: returns the file size of an input file (readable format) {{{2
function fileSize(){
du -h $1 | awk '{print $1}'
}

# rbash: reset environment variables and reload bashprofile {{{2
function resource() {
clear
source $HOME/.zshrc
}

# virtualenv wrapper {{{2
function prepvirtualwrapper() {
  if [[ -f /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh ]] ; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/dev
    if [[ ! -d $WORKON_HOME ]] ; then
      mkdir $WORKON_HOME 
    fi
    . /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh
  else
    echo "*** virtualenvwrapper does not seem to be installed$" >&2
  fi
}
# prepvirtualwrapper

# Inside a tmux session {{{2
if [[ -n $TMUX ]] ; then

  # rtmux: reset the tmux source-file {{{3
  function rtmux() {
  if [[ $TERM == screen* ]] && [[ -n $SSH_CONNECTION ]] ; then
    tmux source-file $TMUX_CONF_NEST
  else
    tmux source-file $TMUX_CONF
  fi
  resimwin
}

# tmclean: cleanup existing sessions (kill all numbered sessions) {{{3
function tmclean(){
this_session=$(tmux display -p '#S')
# Kill defunct sessions first
old_sessions=$(tmux ls 2>/dev/null | egrep "^[0-9]{14}" | grep -v "$this_session" | cut -f 1 -d:)
for old_session_id in $old_sessions; do
  echo "kill old tm-session: $old_session_id"
  tmux kill-session -t $old_session_id
done
  }

fi
# Local-system specific functions {{{1o 
if [[ "$COMP_TYPE" == "local" ]] ; then
  # Make skeleton python package {{{2
  function pyskeleton(){
  dest=$1
  if [[ "x$dest" == "x" ]] ; then
    echo "${ERROR_RED}*** Please suply a destination name${NC}"
    return
  elif [[ -d $dest ]] ; then
    echo "${ERROR_RED}*** The directory $dest already exists${NC}"
    return
  fi
  git clone cello:/home/derekt/dev/py-skeleton.git $dest
  echo "${BLUE_BRIGHT}skeleton $dest created$NC"

  pushd . > /dev/null
  cd $dest

  # remove the ability to push back to skeleton repository
  git remote rm origin
  echo "${RED}- origin removed, cannot push${NC}"
  
  # rename the appropriate files to have the new package name
  git mv NAME $dest
  git mv $(ls tests/NAME_tests.py) tests/${dest}_tests.py

  # account for the renamed python package
  tmp=$(mktemp -t $(basename $0).XXX)
  sed "s/NAME/$dest/g" setup.py > $tmp
  mv $tmp setup.py
  sed "s/NAME/${dest}/g" tests/${dest}_tests.py > $tmp 
  mv $tmp tests/${dest}_tests.py

  # make the first commit
  git add .
  git ci -m "Rename skeleton package to $dest"

  # return
  popd > /dev/null
  

  
  }

  # fullpath: toggles full-path shown in finder {{{2
  function fullpath() {
  echo "fullpath: input=\"$1\""
  # changes Finder so that it shows the full directory path in the top
  # requires input of either "YES" or "NO"
  if [[ "$1" == "YES" ]] || [[ "$1" == "NO" ]] ; then
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool $1
  else
    # correct input was not supplied, so assume "YES"
    echo "*** input is invalid, must be either \"YES\" or \"NO\""
    echo "*** assuming: input=\"YES\""
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES 
  fi

  # restart the Finder app
  killall Finder
  }

# gn: popup a growl notification {{{2
function gn() {
title=$1
message=$2
shift 2

growlnotify $title -m $message $@
   }

   # myip: return a list of ip's being used by the system {{{2
   function myip() {
   if [ "x$1" == "x" ] ; then
     tempFile=".temp.ip"
     curl -s icanhazip.com > $tempFile
     cat $tempFile
     rm $tempFile
   else
     ePort="en0"
     wPort="en1"

     if [ "$1" == "-e" ] ; then
       # request for LOCAL ethernet ip
       ipconfig getifaddr $ePort
     elif [ "$1" == "-w" ] ; then
       # request for LOCAL wifi ip
       ipconfig getifaddr $wPort
     else
       # unkown input, give help text
       echo "myip: $@"
       echo ""
       echo "  myip => retrieves external ip, requires an intrnet connection" 
       echo ""
       echo "  Subcommands:"
       echo "    -e      local IP of ethernet port"
       echo "    -w      local IP of wireless port"
     fi
   fi

 }

 # voices: list possible voices for the say command {{{2
 function voices() {
 ls /System/Library/Speech/Voices | sed 's/.SpeechVoice//g' | grep -v "Compact" 
    }

    # setvol: change volume {{{2
    function setvol() {
    osascript -e "set Volume $1"
  }

  # volmute: mute computer {{{2
  function volmute(){
  setvol 0
}

#---tmmat/tmoct: matlab inside tmux--- {{{2
function tmmat(){
matW=$(tmux lsw | grep "matlab" 2> /dev/null)
if [[ "x$matW" == "x" ]] ; then
  tmux new-window -n "matlab" \
    "cd $MATLAB ;  
  tmvim -h -p 70 $MATLAB ; 
  rmat -a"
else
  tmux select-window -t "matlab"
fi
 }

 function tmoct(){
 octW=$(tmux lsw | grep "octave" 2> /dev/null)
 if [[ "x$octW" == "x" ]] ; then
   tmux new-window -n "octave" \
     "cd $MATLAB ;  
   tmvim -h -p 65 $MATLAB ; 
   $HOME/bin/hili octave -q;"
 else
   tmux select-window -t "octave"
 fi
}
# wiki: wiki dictionary search {{{2
function wiki() {
# perform search and highlight the search term (grep-style)
search=$(dig +short txt ${1}.wp.dg.cx | perl -pe 's/'"$1"'/\\033['"${GREP_COLOR}"'m'"${1}"'\'"$NC"'/ig')
echo -e $search
   }

   function archinit() { 
   ang=$1 ; 
   len=$2; 
   file=$(ls run_*_ang-${ang}_len-${len}_*.input) && {
   cp $file data.input ; 
   kesshou -si ; 
   tar cvf a-${ang}_l-${len}.tar ${file%.input}.txt init.data ; 
 }
   }

   # Central/Remote Systems {{{1o
 elif [[ "$COMP_TYPE" == "central" ]] || [[ "$COMP_TYPE" == "remote" ]] ; then
   # myip: find my local network ip address {{{2
   function myip() {
   for ip in $(hostname -i); do 
     final=${ip##*.}; 
     first=${ip%%.*}; 
     if [[ $final -gt 100 ]] && [[ $first -eq 192 ]] ; then 
       my_ip=$ip; 
       break; 
     fi ; 
     echo $my_ip
   done
 }

 # qinfo: get useful info from qstat {{{2
 # this requires a system with pbs
 function qinfo() {
 info=$(qstat -Q | tail -1)

 # limit of available runs, number of queued procs, number of running procs
 limit=$(echo $info | awk '{ print $2}')
 nQ=$(echo $info | awk '{ print $6}')
 nR=$(echo $info | awk '{ print $7}')

 # was there input?
 if [ "x$1" == "x" ] ; then
   echo "qinfo:"
   echo "  limit:  $limit"
   echo "  queue:  $nQ"
   echo "  run:    $nR "
 else
   query=$1
   length=$2
   case $query in
     l)
       echo $limit
       ;;
     q)
       echo $nQ
       ;;
     r)
       echo $nR
       ;;
     qratio)
       rat=$(echo "$nQ/$limit" | bc -l)
       if [[ $length -gt 1 ]] ; then 
         echo ${rat:0:$length}
       else
         echo ${rat:0:5}
       fi
       ;;
     rratio)
       rat=$(echo "$nR/$limit" | bc -l)
       if [[ $length -gt 1 ]] ; then 
         echo ${rat:0:$length}
       else
         echo ${rat:0:5}
       fi
       ;;
     *)
       echo "*** Unkown qinfo query: \"$1\""
       ;;
   esac
 fi
 }
fi


