#!/bin/bash

# get colors
if [[ -f $HOME/.colors ]] ; then
    . $HOME/.colors
fi

gems=( "maid" "terminal-notifier" "vmail" "compass" "pdfbeads" )
pips=( "virtualenv" "virtualenvwrapper" "fabulous" "docutils" "ipython" "pygments" "pyzmq" "git+https://github.com/hyde/typogrify.git#egg=typogrify-hyde" "cython" "lxml" "nose" "psutils" )
pip_editable=( "git://github.com/hyde/hyde.git#egg=hyde" "git+https://github.com/Lokaltog/powerline.git@develop#egg=powerline" "$HOME/dev/crystalpy" )
reference=( "numpy" "scipy" "git+https://github.com/matplotlib/matplotlib.git#egg=matplotlib-dev" )


case $1 in
    -r | --ruby)
        echo "installing: ${RED_BRIGHT}ruby-gems${NC}"
        echo "------------------------------"

        if [[ -z $GEM ]] ; then
            GEM=$(which gem)
            echo "Warning: GEM is not set, assuming GEM='$GEM'"
        fi
        if [[ -z $GEM_HOME ]] ; then
            echo "Warning: GEM_HOME is not set, this may require use of 'sudo'"
        fi
        for g in ${gems[@]} ; do
            echo ${YELLOW_BRIGHT}$GEM install $g${NC}
            $GEM install $g
        done
        ;;
    -p | --python)

        echo "installing: ${GREEN_BRIGHT}python modules${NC}"
        echo "------------------------------"
        opts="--user"

        if [[ -z $PIP ]] ; then
            PIP=$(which pip)
            echo "Warning:PIP is not set, assuming PIP='$PIP'"
        fi

        if [[ ! -z $UPGRADE ]] ; then
            opts="$opts --upgrade"
        fi

        for p in ${pips[@]} ; do
            echo ${YELLOW_BRIGHT}$PIP install $opts $p${NC}
            $PIP install $opts $p
        done
        # install from dev eggs in ~/.pip directory
        pushd . > /dev/null
        echo
        echo ${BLUE_BRIGHT}cd ~/.pip${NC}
        mkdir -p ~/.pip/editable
        cd ~/.pip/editable
        for p in ${pip_editable[@]} ; do
            echo ${YELLOW_BRIGHT}${PIP} install $opts -e $p${NC}
            ${PIP} install $opts -e $p
        done
        popd > /dev/null
        ;;
    -u | --upgrade)
        UPGRADE=1 $0 -r
        UPGRADE=1 $0 -p
        ;;
    *)
        echo "Usage: $(basename $0) [-p] [-r] [-u]

        -p, --python      install python modules
        -r, --ruby        install ruby gems
        -u, --upgrade     upgrade both ruby and python "


        ;;
esac
