# Unity Shell

I set out to create a set of useful commandline functions, aliases,
and environment variables among with bundled programs to help unify a
series of computers than cannot use the same shell. I have some remote
servers that have outdated `bash` running on them, and without root
priveleges. But, I still want to keep them all running similarly. That's
why I created the Unity Shell project. Most of the shell commands and
functions are `sh` compatible and are located in the "Unity" directory.
Those that are bash or zsh specific are in their respective folders.

## Getting started

There is a little bit of easy setup to get these files running on any machine.

    $ git clone git@github.com:scicalculator/Unity-Shell.git ~/.rcfiles
    $ cd ~/.rcfiles
    $ git submodule init
    $ git submodule update
    $ ./setup.sh

The setup script that is run at the end will try to setup your machine
as one of 3 types. A *central* (firewall) server, a *local* (laptop,
desktop, etc.) computer, or a *remote* server. It then asks you to
select your desired shell and if possible it moves the relevant shell
startup files to the home directory.

After that it goes through directory and collect as many relevant
executables as possible and soft-link them to the home directory's
bin folder. It also moves the vim folder and modules folder to
easy-to-locate positions in the home directory (`~/.vim` and
`~/.rcbundes` respectively).

At this point, you'll want to reload your shell: 1) close and reopen the
shell or 2) `source ~/.$(basename ${SHELL})rc`. Now, let's install some
of the compilable programs. Run these commands:

    $ cd ~/.rcfiles

    # for compiled programs in ~/.rcbundles/*
    $ ./builders/remake.py

    # for helpful python-pip and ruby-gems installations
    $ ./builders/mod_install.sh

Don't worry, I tried very hard to make sure that these files all install
to the directory `~/local` so that you shouldn't need root priveleges to
install anything.

Last, but not least, let's update our vim installation, assuming you've reloaded your shell

    $ cd ~/.vim

    # now to use some of the helpful tools, such as extensive git aliases
    $ g subinit 
    $ g subup

    # updating? 
    $ g submaster

## What's in here?

Right now, there isn't a written up review of the available commands
that come in here, but if you look through the modules, it should be
rather straight forward.

