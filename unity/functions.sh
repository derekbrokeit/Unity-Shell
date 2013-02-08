
# Universal functions {{{1o
pid_with_children() {  #{{{2
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

kill_with_children() {  #{{{2
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

# vs, ms, viw: vim functions  {{{2
vs () { #{{{3
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
    ms () { #{{{3
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

vs_restart () { #{{{3
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

conv_time_stamp() {  #{{{2
    # convertTimeStamp: convert a time stamp from seconds-from-epoch to readable format
    # converts from seconds-from-epoch to readable format of date-timestamp
    if [[ "$(uname)" == "Darwin" ]] ; then
        date -r $1
    else
        date -d @$1
    fi
}

resource() { #{{{2
    # rbash: reset environment variables and reload bashprofile
    clear
    source $HOME/.$(basename $SHELL)rc
}
## rbash: reset environment variables and reload bashprofile
#rbash() {
#clear
#ps_temp="$PS1"
#source $BASH_PROFILE
#export PS1="$ps_temp"
#}


prepvirtualwrapper() { #{{{2
    # virtualenv wrapper
    if is_avail virtualenvwrapper.sh ; then
        export WORKON_HOME=$HOME/.virtualenvs
        export PROJECT_HOME=$HOME/.virtualenv_dev
        mkdir -p $PROJECT_HOME $WORKON_HOME
        . $(command -v virtualenvwrapper.sh)
    else
        echo "*** virtualenvwrapper does not seem to be installed$" >&2
    fi
}

colorlist() { #{{{2
    # printcolor: print the available 256 colors
    # the colour codes will work in tmux
    printf "\ttmux-fg \t\t tmux-bg \t [bash(fg=\\ x1b[38;5;\${i}  bg=\\ x1b[48;5;\${i}m )]\n"
    for i in {0..255} ; do
        printf "\x1b[38;5;${i}m i=${i} \tcolour${i}\e[0m \t\x1b[48;5;${i}m\tcolour${i} \t\e[0m\n"
    done
}

# Inside a tmux session {{{2
if [[ -n $TMUX ]] ; then

    rtmux() { #{{{2
        # rtmux: reset the tmux source-file
        if [[ $TERM == screen* ]] && [[ -n $SSH_CONNECTION ]] ; then
            tmux source-file $TMUX_CONF_NEST
        else
            tmux source-file $TMUX_CONF
        fi
        resimwin
    }

    tmclean(){ #{{{2
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

# Local-system specific functions {{{1o
if [[ "$COMP_TYPE" == "local" ]] ; then
    pyskeleton(){ #{{{2
        # Make skeleton python package
        dest=$1
        if [[ "x$dest" == "x" ]] ; then
            echo "${ERROR_RED}*** Please suply a destination name${NC}"
            return
        elif [[ -d $dest ]] ; then
            echo "${ERROR_RED}*** The directory $dest already exists${NC}"
            return
        fi
        git clone cello:~/dev/py-skeleton.git $dest
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

    fullpath() { #{{{2
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

    myip() { #{{{2
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

    voices() { #{{{2
        # voices: list possible voices for the say command
        ls /System/Library/Speech/Voices | sed 's/.SpeechVoice//g' | grep -v "Compact"
    }

    setvol() { #{{{2
        # setvol: change volume
        osascript -e "set Volume $1"
    }

    volmute(){ #{{{2
        # volmute: mute computer
        setvol 0
    }

    wiki() { #{{{2
        # wiki: wiki dictionary search
        # perform search and highlight the search term (grep-style)
        search=$(dig +short txt ${1}.wp.dg.cx | perl -pe 's/'"$1"'/\\033['"${GREP_COLOR}"'m'"${1}"'\'"$NC"'/ig')
        echo -e $search
    }

    archinit() { #{{{2
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
    myip() { #{{{2
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

    qinfo() { #{{{2
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
        djvu_file=$1
        pushd . > /dev/null
        tmp=$(mktemp -d -t djvu_ocr_pdf.XXX)
        echo $tmp
        cp $djvu_file $tmp/tmp.djvu
        cd $tmp
        for i in {1..428} ; do
            ii=$(printf "%010d" $i)
            djvu2hocr -p ${ii} tmp.djvu | sed 's/ocrx/ocr/g' > tmp_${ii}.html
            ddjvu -format=tiff -page=${ii} tmp.djvu tmp_${ii}.tif
        done
        pdfbeads -o tmp.pdf
        popd > /dev/null
        cp $tmp/tmp.pdf ${djvu_file%.djvu}.pdf
    }
fi

