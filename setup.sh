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
            chsh -s /bin/$shell && echo '! Success'
            if [[ $? -gt 0 ]] ; then
                echo '*** Error changing shells '
            else
                touch $chshfile
                break
            fi
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

collectbin(){
    mkdir -p $HOME/bin
    #for dir in $(find $abs_path/bundle -type d -regex ".*\/bin" )
    for dir in $(find $bundles -type d -regex ".*\/bin" )
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
    ignore=$abs_path/.ignore_bundles
    touch $ignore
    tmp=$(mktemp -t $(basename $0).XXX)
    find $bundles -executable > $tmp
    for file in $(cat $tmp) ; do
        link=$HOME/bin/$(basename $file)
        if [[ "x$(grep $file $ignore)" == "x" && ! -d $file && ! -L $link ]] ; then
            # criteria:
            #        1. Not in the ignore list
            #        2. not a directory
            #        3. no link already exists
            while [[ 1 ]] ; do
                printf "ln -s $file ~/bin/$(basename $file) ? (y/N) "
                read  yn
                case $yn in
                    [yY] )
                        echo "ln -s $file $link"
                        ln -s $file $link
                        break
                        ;;
                    * )
                        echo $file >> $ignore
                        break
                        ;;
                esac
            done
        fi
        #read line
    done
    IFS="$OIFS"
    rm $tmp &> /dev/null
    echo "## -- ignoring bundles ($ignore)"
    cat $ignore
}
echo "## -- collecing executables"
bundles=$HOME/.rcbundles
echo "ln -s $abs_path/bundle $bundles"
if [[ ! -L $bundles ]] ; then
    ln -s $abs_path/bundle $bundles
fi
bundles=$bundles/
collectbin

echo "## -- setup up vim"
if [[ -L $HOME/.vim ]] ; then
    rm $HOME/.vim
fi
ln -s $abs_path/vim $HOME/.vim
cd $HOME/.vim
./setup.sh

## return to the original directory
popd > /dev/null

echo "## -- you may need to restart your terminal for changes to take effect"

