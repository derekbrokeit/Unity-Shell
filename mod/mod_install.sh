#!/bin/bash

# get colors
if [[ -f $HOME/.colors ]] ; then
    . $HOME/.colors
fi

gems=( "maid" "terminal-notifier" "vmail" "compass" )
pips=( "virtualenv" "virtualenvwrapper" "fabulous" "docutils" "numpy" "scipy" "ipython" "pygments" "pyzmq" )
#pip_eggs=( "git+https://github.com/scipy/scipy#egg=scipy-dev" "git+https://github.com/matplotlib/matplotlib.git#egg=matplotlib-dev" "git://github.com/hyde/hyde.git#egg=hyde" )
pip_eggs=( "git+https://github.com/matplotlib/matplotlib.git#egg=matplotlib-dev" "git+https://github.com/hyde/typogrify.git#egg=typogrify-hyde" "git://github.com/hyde/hyde.git#egg=hyde" )


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
        [[ $COMP_TYPE != "local" ]] && opts="--install-option=--prefix=$HOME/local" || opts=""

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
        # install from dev eggs
        for p in ${pip_eggs[@]} ; do
            echo ${YELLOW_BRIGHT}${PIP} install $opts -e $p${NC}
            ${PIP} install $opts -e $p
        done
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
