#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess, os, sys

try:
    from fabulous.color import green, yellow,  bold, red, cyan
except ImportError:
    def return_to_sender(text): return text
    green  = return_to_sender
    yellow = return_to_sender
    red  = return_to_sender
    cyan   = return_to_sender
    bold   = return_to_sender

dirname, filename = os.path.split(os.path.abspath(__file__))
cwd          = os.getcwd()

bundle = {
        "ag":{
                "dir":      "bundle/ag",
                "make" :    ["./build.sh","make clean","./configure --prefix=$HOME/local", "make", "make install"],
                "clean":    "make clean"
            },
        "stderred":{
                "dir":      "bundle/stderred",
                "make":     ["make all"],
                "clean":    "make clean"
            },
        "matplotlib":{
                "dir":      "bundle/matplotlib",
                "make":     ["python setup.py install --prefix=$HOME/local"],
                "clean":    None
            },
        "tig":{
                "dir":      "bundle/tig",
                "make":     ["make", "make install install-doc"],
                "clean":    "make clean"
            }
        }

def cmd_gen(cmd):
    return [s.replace("$HOME",os.environ["HOME"]) for s in cmd.split()]

def clean(items):
    for name, props in items:
        # only attempt if the clean method exists
        if props["clean"]:
            print
            print "clean: %s" % (cyan(name))
            print "-"*30

            # move to this files parent directory and then to the bundle directory
            os.chdir(dirname + "/..")
            os.chdir(props["dir"])

            print yellow(props["clean"])
            subprocess.call(props["clean"].split())

def make(items):
    for name, props in items:
        print
        print "make: %s" % (cyan(name))
        print "-"*30

        # move to this files parent directory and then to the bundle directory
        os.chdir(dirname + "/..")
        os.chdir(props["dir"])

        for cmd in props["make"]:
            print yellow(cmd)
            c = subprocess.call(cmd_gen(cmd))
            if c != 0:
                print red("Error encountered (%s: %s)" % (cyan(name), yellow(cmd)))
                sys.exit()

def print_list():
    print "%-15s%+15s" % ("Name", "Directory")
    print "-"*30

    b_list = bundle.items()
    b_list.sort()

    for name, props in b_list:
        print "%-15s%-15s" % (name, props["dir"])

def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--clean_all",
            help="Clean all bundles",
            action="store_true")
    parser.add_argument("--make_all",
            help="Make all bundles and install them",
            action="store_true")
    parser.add_argument("-c","--clean",
            help="Clean BUNDLES",
            action="store_true")
    parser.add_argument("-m","--make",
            help="Make BUNDLES",
            action="store_true")
    parser.add_argument("-l","--list",
            help="List the current bundles and their directories",
            action="store_true")
    parser.add_argument("bundles", type=str, nargs="*",
            help="Make and install given BUNDLES")
    args = parser.parse_args()

    # print out the total list
    if args.list:
        print_list()
        sys.exit()

    bundles = [(b, bundle[b]) for b in args.bundles]
    if args.clean:            # clean selected bundles
        clean(bundles)
    elif args.make:           # make selected bundles
        make(bundles)
    elif bundles:             # nothing specified, but bundles selected, so make
        make(bundles)
    elif args.clean_all:      # clean all bundles
        clean(bundle.items())
    else:                     # default: make all bundles
        make(bundle.items())

if __name__ == "__main__":
    main()
