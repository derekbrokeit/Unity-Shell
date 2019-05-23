#export EDITOR="$HOME/bin/tmvim"
export EDITOR=nvim
if os_is_linux ; then
    export BROWSER=google-chrome-stable
else
    export BROWSER=v3m
fi

export PAGER="nvimpager"
export MANPAGER="$PAGER"
alias less=$PAGER
ccat() {
    # local cols=$(tput cols)
    local cols=20
    printf "${CYAN}%${cols}s${NC}\n" | tr " " -
    vimcat -c "hi Normal ctermbg=NONE" $@
    printf "${CYAN}%${cols}s${NC}\n" | tr " " -
}

# export GNUTERM=dumb
# export VMAIL_HTML_PART_READER="w3m -dump -o display_link_number=1 "
# export VMAIL_VIM=mvim

# vim temporary directory for swap files
export EDITOR_TMP="${HOME}/.${EDITOR}-tmp"

# # tmux files
# export TMUX_CONF="$HOME/.tmux.conf"
# export TMUX_CONF_NEST="${TMUX_CONF}.nested"
# export TMUX_CONF_TMWIN="${TMUX_CONF}.tmwin"
# export TMUX_CONF_MINI="${TMUX_CONF}.mini"

# # virtualenvwrapper
# export VIRTUALENVWRAPPER_PYTHON=$(command -v python)

# python startup file
export PYTHONSTARTUP=$HOME/.pythonrc.py

# language variables
# some systems throw an error when using locale, so throw errors to null
export LANG="$(locale -a 2> /dev/null | egrep 'en_US.*(utf|UTF)')"
if os_is_linux ; then
    export LOCALE=UTF-8
else
    export LC_ALL=$LANG
fi

# # grep coloring
# if os_is_osx ; then
#     export GREP_OPTIONS='--color=auto'
#     export GREP_COLOR='1;32'
# fi

# colorful man-pages
# Less Colors for Man Pages
export LESS="-R"
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export LS_OPTIONS="--color=auto"
if [ ! -s ~/.dir_colors ]; then
    #setup ~/.dir_colors for ls if one does not exist
    if is_avail dircolors ; then
        dircolors -p > ~/.dir_colors
        dircolors ~/.dir_colors
    elif is_avail gdircolors ; then
        gdircolors -p > ~/.dir_colors
        gdircolors ~/.dir_colors
    fi
fi

if [[ -d $HOME/Dropbox ]] ; then
    export DROPBOX="$HOME/Dropbox"
fi

if is_avail lammps ; then
    export LAMMPS_COMMAND=$(command -v lammps)
    if is_avail brew ; then
        export LAMMPS_POTS=$(brew --prefix )/share/lammps/potentials
        export LAMMPS_DOCS=$(brew --prefix )/share/lammps/doc
        export LAMMPS_LIB=$(brew --prefix )/lib/liblammps.so
    else
        export LAMMPS_POTS=$HOME/repo/lammps/potentials
        export LAMMPS_DOCS=$HOME/repo/lammps/doc
        export LAMMPS_LIB=/usr/local/lib/liblammps.so
    fi
fi

export PS1="\[$(printf $YELLOW_BRIGHT)\]${HOSTNAME:0:1} > \[$(printf $NC)\]"

export SSHFS_DIR="$HOME/sshfs"

if os_is_linux ; then
    # make sure that git doesn't throw errors on https:// sites
    # export GIT_SSL_NO_VERIFY=true

    export HOMEBREW_CACHE=$HOME/.hb_cache
fi

# export ParaView_DIR=/home/derek/OpenFOAM/ThirdParty-2.3.0/platforms/linux64Gcc/ParaView-4.1.0
# export PATH=$ParaView_DIR/bin:$PATH
# export PV_PLUGIN_PATH=$FOAM_LIBBIN/paraview-4.1


## Uncomment the following line to enable pretty prompt:
#export MOOSE_PROMPT=true
## Uncomment the following line to enable autojump:
#export MOOSE_JUMP=true
## Source the MOOSE profile if moose_profile exists:
# if [ -f /opt/moose/environments/moose_profile ]; then
#   . $HOME/.moose_profile
# fi

export PYTHONBREAKPOINT=pudb.set_trace
