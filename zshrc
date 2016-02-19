
# export LANG="en_US.UTF-8"
# export LOCALE="UTF-8"

os_is_linux() { [[ $OSTYPE == 'Linux' || $OSTYPE == 'bsd' ]] ; }
if os_is_linux ; then
    export POWERLINE_CONFIG_COMMAND=/usr/bin/powerline-config
    export POWERLINE_COMMAND=/usr/bin/powerline
fi

# source the .bash_profile file instead
source $HOME/.zsh/zshrc

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

if os_is_linux ; then
    powerline-daemon -q
    alias of230='module load mpi/openmpi-x86_64; source $HOME/OpenFOAM/OpenFOAM-2.3.0/etc/bashrc WM_NCOMPPROCS=4'
fi
