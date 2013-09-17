#!/bin/sh

linker(){
    source=$1
    destination=$2
    if [[ ! -L $destination ]] ; then
        echo ln -s $source $destination
        ln -s $source $destination
    else
        echo "link-exists: $destination"
    fi
}

## make sure that the script is being called from the right directory
abs_path=$(cd "$(dirname "$0")"; pwd)
cd $abs_path

if [[ $COMP_TYPE == "local" ]] && [[ -d $HOME/Dropbox ]] ; then
    LOGS_DIR=$HOME/Dropbox/serverLogs
    mkdir -p $LOGS_DIR
else
    FAIL_LOGS_DIR=0
fi

# link shell files
links=( unity zsh zshrc bash bashrc bash_profile )
echo "##-- linking shell files"
for l in ${links[@]} ; do
    linker $PWD/$l $HOME/.$l
done
linker unity/profile.sh $HOME/.profile

## setup symbolic links
echo "##-- linking misc files"
cd $abs_path/misc
for file in $(ls) ; do
    linker $PWD/$file $HOME/.$file
done

echo "## -- setup up vim"
cd $abs_path
linker $PWD/vim $HOME/.vim
cd $PWD/vim
./setup.sh

echo "## -- setup config files"
cd $abs_path/config
if [[ ! -d $HOME/.config ]] ; then
    mkdir -p $HOME/.config
fi
for d in $(ls); do
    linker $PWD/$d $HOME/.config/$d
done

echo "## -- setup bin files"
cd $abs_path/bin
for f in $(ls) ; do
    linker $PWD/$f $HOME/bin/$f
done

echo "## -- you may need to restart your terminal for changes to take effect"

