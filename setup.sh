#!/bin/sh

## make sure that the script is being called from the right directory
pushd . > /dev/null
abs_path=$(cd "$(dirname "$0")"; pwd)
cd $abs_path

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

        if [[ "x$shell" == "x" ]] ; then
            #input of nothing will simply stop trying
            echo "*** No shell scripts chosen at this time"
            break
        fi
        # in case the user puts in /bin/bash instead of bash
        shell=${shell##*/}
        # see if there are any startup scipts
        found=0
        for file in $(find . -maxdepth 1 ) ; do
            if [[ $file == "./$shell"* ]] ; then
                found=1
                file=${file#./}
                #link the startup scripts
                rm $HOME/.$file &> /dev/null
                ln -s $PWD/$file $HOME/.$file
                echo "ln -s $file \$HOME/.$file"
            fi
        done
        if [[ $found -eq 1 ]] ; then
            # attempt to change the shell
            echo "- changing shell to '$shell'"
            { chsh -s /bin/$shell && echo '! Success' ; touch $chshfile ; } || echo '*** Error changing shells '
                break
            else
                #no startup scripts, so we can't
                echo '*** Startup scripts for that shell were not found'
            fi
        done
    else
        # the choice has been made, but make sure the links are in place
        echo "## -- setting up shell -- ##"
        shell=${SHELL##*/}
        for file in $(find . -maxdepth 1 ) ; do
            if [[ $file == "./$shell"* ]] ; then
                file=${file#./}
                rm $HOME/.$file &> /dev/null
                ln -s $PWD/$file $HOME/.$file
                echo "ln -s $file \$HOME/.$file"
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

    ## setup bundles
    if [[ -L $HOME/.rcbundles ]] ; then
        rm $HOME/.rcbundles
    fi
    ln -s $dir/bundle $HOME/.rcbundles

    collectbin(){
        mkdir -p $HOME/bin
        for dir in $(find $abs_path/bundle -type d -regex ".*\/bin" )
        do
            for file in $(ls $dir) ; do
                if [[  -f $HOME/bin/$file || -L $HOME/bin/$file ]] ; then
                    # there is already file or link in the desired bin directory :(
                    if [[ "$1" == "-v" || "$1" == "--verbose" ]] ; then
                        echo "Skipping $dir/$file ... already exists in ~/bin"
                    fi
                else
                    echo "ln -s $dir/$file $HOME/bin/$file"
                    ln -s $dir/$file $HOME/bin/$file
                fi
            done
        done
        echo "## -- executables in non-standard directories"
        OIFS="$IFS"
        IFS=$'\n'
        for file in $(find $abs_path/bundle -executable) ; do
            if [[ -d "$file" ]] ; then
                continue
            elif [[ ! -L $HOME/bin/$(basename $file) ]] ; then
                while [[ 1 ]] ; do
                    read -p "ln -s $file ~/bin/$(basename $file) ?(y/n) " yn
                    case $yn in
                        [yY] )
                            echo "ln -s $file $HOME/bin/$(basename $file)"
                            ln -s $file $HOME/bin/$(basename $file)
                            break
                            ;;
                        [nN] )
                            break
                            ;;
                    esac
                done
            fi
            #read line
        done
        IFS="$OIFS"

    }
    echo "## -- collecing executables"
    collectbin


    ## return to the original directory
    popd > /dev/null

    echo "## -- you may need to restart your terminal for changes to take effect"
