
# Universal functions
pid_with_children() {
    # pid-with-children: list a process with all its children
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

kill_with_children() {
    # kill-with-children: kill a process and all its children

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

# vs, ms, viw: vim functions
vs () {
    if [[ "x$@" != "x" ]] ; then
        sname=$1
        ed="$EDITOR"
        shift 1
    else
        sname="vim"
        if [[ $(uname) == "Darwin" ]] ; then
            ed="mvim"
        else
            ed="gvim"
        fi
    fi
    $ed -p --servername $sname --remote-tab $@
}

if is_avail mvim ; then
    ms () {
        if [[ "x$@" != "x" ]] ; then
            opts="--remote-tab-silent"
            mvim --servername vim $opts $@
        else
            osascript -e 'tell application "MacVim"' \
                -e "activate"                  \
                -e "end tell"
        fi
    }
fi

vs_restart () {
    if [[ "$(uname)" == "Darwin" && "x$@" == "x" ]] ; then
        serv="vim"
        ed="mvim"
    else
        if [[ "x$@" != "x" ]] ; then
            serv="$1"
            shift 1
        else
            serv="gvim"
        fi
        ed="$EDITOR"
    fi
    sess_file="$HOME/.vim-tmp/restart_sessionFile.vim"
    echo $ed --servername $serv --remote-send '<Esc>:mksession ~/.vim-tmp/sessionFile.vim<CR>:wqa<CR>'
    # save the session and quit out of it
    $ed --servername $serv --remote-send "<Esc>:mksession! $sess_file<CR>:wqa<CR>"
    echo "source $MYVIMRC" >> $sess_file
    # now open in back up in terminal editor (this usually should only be called when ssh'd into a server anyway)
    # if [[ $? -gt 0  ]] ; then
    $EDITOR --servername $serv -S $sess_file
    # else
    #     ! echo "*** Error ($?) occured while accessing server: $serv"
    # fi
}

conv_time_stamp() {
    # convertTimeStamp: convert a time stamp from seconds-from-epoch to readable format
    # converts from seconds-from-epoch to readable format of date-timestamp
    if [[ "$(uname)" == "Darwin" ]] ; then
        date -r $1
    else
        date -d @$1
    fi
}

resource() {
    # rbash: reset environment variables and reload bashprofile
    clear
    source $HOME/.$(basename $SHELL)rc
}

pyvirt() {
    # virtualenv wrapper
    if [[ "$1" == "2" ]] ; then
        export VIRTUALENVWRAPPER_PYTHON=$(command -v python)
    else
        export VIRTUALENVWRAPPER_PYTHON=$(command -v python3)
    fi

    if is_avail virtualenvwrapper.sh ; then

        export WORKON_HOME=$HOME/.virtualenvs
        export PROJECT_HOME=$HOME/.virtualenv_dev
        mkdir -p $PROJECT_HOME $WORKON_HOME
        . $(command -v virtualenvwrapper.sh)
    else
        echo "*** virtualenvwrapper does not seem to be installed$" >&2
    fi
}

colorlist() {
    # printcolor: print the available 256 colors
    # the colour codes will work in tmux
    printf "\ttmux-fg \t\t tmux-bg \t [bash(fg=\\ x1b[38;5;\${i}  bg=\\ x1b[48;5;\${i}m )]\n"
    for i in {0..255} ; do
        printf "\x1b[38;5;${i}m i=${i} \tcolour${i}\e[0m \t\x1b[48;5;${i}m\tcolour${i} \t\e[0m\n"
    done
}

ignored_filetypes(){
    # lists the currently ignored filetypes
    cat ~/.cvsignore | tr '\n' ' '
}

change_deliminator(){
    # takes piped in input and outputs the text with a change of deliminator
    from=$1
    to=$2
    awk 'BEGIN{FS="'$from'";OFS="'$to'"} {$1=$1; print $0}'
}

dangling_links(){
    # lists the dangling lists recursively
    # args:
    #  N: used to measure depth (optional)
    #  after that are `find` args

    if [[ -n $1 ]] ; then
        local DEPTH=$1
        shift 1
        find -L ./ -maxdepth $DEPTH -type l $@
    else
        find -L ./ -type l $@
    fi
}

# Inside a tmux session
if [[ -n $TMUX ]] ; then

    rtmux() {
        # rtmux: reset the tmux source-file
        if [[ $TERM == screen* ]] && [[ -n $SSH_CONNECTION ]] ; then
            tmux source-file $TMUX_CONF_NEST
        else
            tmux source-file $TMUX_CONF
        fi
        resimwin
    }

    tmclean(){
        # tmclean: cleanup existing sessions (kill all numbered sessions)
        this_session=$(tmux display -p '#S')
        # Kill defunct sessions first
        old_sessions=$(tmux ls 2>/dev/null | egrep "^[0-9]{14}" | grep -v "$this_session" | cut -f 1 -d:)
        for old_session_id in $old_sessions; do
            echo "kill old tm-session: $old_session_id"
            tmux kill-session -t $old_session_id
        done
    }

fi

# Local-system specific functions
if os_is_osx ; then
    socksproxy(){
        if [[ "x$2" = "x" ]] ; then
            dev="Wi-Fi"
        else
            dev="$2"
        fi

        if [[ "x$1" != "x" ]] ; then
            switch=$1
        else
            if networksetup -getsocksfirewallproxy $dev | grep Yes 2>&1 > /dev/null ; then
                switch=off
            else
                switch=on
            fi
        fi
        # taking 'sudo' off brings the
        networksetup -setsocksfirewallproxystate $dev $switch && echo "socks proxy ($dev) is now $switch"
    }

    tsshproxy(){

        if [[ "x$1" = "x" ]] ; then
            # make sure to always try to turn off the socks proxy on exit
            trap "socksproxy off" EXIT
            # turn on socks proxy
            socksproxy on && tssh -P
        elif [[ "$1" = "i" ]] ; then
            # make sure to always try to turn off the socks proxy on exit
            trap 'socksproxy off "iPhone USB"' EXIT

            socksproxy on "iPhone USB" && tssh -P
        else
            echo "tsshproxy: invalid option"
        fi
    }

    fullpath() {
        # fullpath: toggles full-path shown in finder
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

    myip() {
        # myip: return a list of ip's being used by the system
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

    voices() {
        # voices: list possible voices for the say command
        ls /System/Library/Speech/Voices | sed 's/.SpeechVoice//g' | grep -v "Compact"
    }

    setvol() {
        # setvol: change volume
        osascript -e "set Volume $1"
    }

    volmute(){
        # volmute: mute computer
        setvol 0
    }

    volmax(){
        setvol 10
    }

    wiki() {
        # wiki: wiki dictionary search
        # perform search and highlight the search term (grep-style)
        search=$(dig +short txt ${1}.wp.dg.cx | perl -pe 's/'"$1"'/\\033['"${GREP_COLOR}"'m'"${1}"'\'"$NC"'/ig')
        echo -e $search
    }


else
    myip() {
        # myip: find my local network ip address
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
fi

if is_avail gs ; then
    merge_pdf() {
        gs \
            -o merged.pdf \
            -sDEVICE=pdfwrite \
            -dPDFSETTINGS=/prepress $@
    }
    compress_pdf() {
        if [[ -z $2 ]] ; then
            output="output.pdf"
        else
            output=$2
        fi
        gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dBATCH -sOutputFile=$2 $output
    }
fi
if is_avail djvu2hocr ; then
    djvu_ocr_pdf() {
        if [[ "$1" == "-n" ]] ; then
            pn=$2
            shift 2
            echo "converting $pn pages"
        else
            pn=1000
            echo "assuming $pn pages ... may need correction with '-n' flag"
        fi
        djvu_file=$1
        pushd . > /dev/null
        tmp=$(mktemp -d -t djvu_ocr_pdf.XXX)
        echo $tmp
        cp $djvu_file $tmp/tmp.djvu
        cd $tmp
        for i in {1..$pn} ; do
            ii=$(printf "%010d" $i)
            { djvu2hocr -p ${ii} tmp.djvu || break ; } | sed 's/ocrx/ocr/g' > tmp_${ii}.html
            ddjvu -format=tiff -page=${ii} tmp.djvu tmp_${ii}.tif
        done
        pdfbeads -o tmp.pdf
        popd > /dev/null
        cp $tmp/tmp.pdf ${djvu_file%.djvu}.pdf
    }
fi

if is_avail qstat ; then
    qinfo() {
        # qinfo: get useful info from qstat
        # this requires a system with pbs
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

if [[ -d /opt/moose ]] ; then
    moose_setup() {
        source $HOME/.moose_profile
        #module load moose-dev-clang moose-tools
    }
fi

if is_avail tmux ; then
    tmx() {
        s=$1
        tmux attach -t $s || tmux new -s $s
    }
fi
