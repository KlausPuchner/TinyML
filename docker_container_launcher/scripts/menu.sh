#!/bin/bash

# Turn off script exit on failure
set +e

## -------------------------------------------------------------------------------

function set_window_size() {
    #Use to set window (Standard: 80*24)
    #echo -e '\033[8;40;80t'
    :
}

function header() {
    echo -e "\e[1m\e[93m"
    cat ./scripts/logo
    echo -e "\e[0m"
    bar
}

function body() {
    #echo
    echo -e "\n  Throwaway Containers\n  --------------------"
    echo -e "  [1]  Jupyter Notebook (Tensorflow 2.4.1, Python 3.6.9, Ubuntu 18.04)"
    echo -e "  [2]  Jupyter Notebook (Tensorflow 1.15.5, Python 3.6.9, Ubuntu 18.04)"
    echo -e "\n  Persistent Containers\n  ---------------------"
    echo -e "  [10]  Jupyter Notebook (Tensorflow 2.4.1, Python 3.6.9, Ubuntu 18.04)"
    echo -e "  [11]  Jupyter Notebook (Tensorflow 1.15.5, Python 3.6.9, Ubuntu 18.04)"
    #echo -e "  [2] RStudio (Tensorflow 2.4.1, R 4.0.4, Python 3.8.5, Ubuntu 20.04)"
    echo
}

function footer() {
    bar
    echo
    read -p "  Type [#] to open Image or [q] to quit: " opt
    echo
}