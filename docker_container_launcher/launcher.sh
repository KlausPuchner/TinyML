#!/bin/bash

## --- Turn off script exit on failure ---
set +e

## --- Create Directory to map into Container ---
mkdir ~/dockervolume > /dev/null 2>&1

## --- Importing Functions and Parameters ---
source ./scripts/initialize.sh
source ./scripts/gpu.sh
source ./scripts/docker.sh
source ./scripts/helper.sh
source ./scripts/menu.sh
source ./scripts/start.sh

## --- Initializing System ---
initialize

## --- Set Terminal Window Size ---
set_window_size

## --- Start Menu ---
while true; do
    clear
    header
    body
    footer

    if [ "$opt" = "1" ] ; then
        start_tf2_jupyter tensorflow 2.4.1 throwaway

    elif [ "$opt" = "2" ] ; then
        start_tf1_jupyter tensorflow 1.15.5 throwaway


    elif [ "$opt" = "10" ] ; then
        start_jupyter tensorflow 2.4.1 

    elif [ "$opt" = "11" ] ; then
        start_jupyter tensorflow 1.15.5 

    elif [ "$opt" = "q" ] ; then
        break

    fi

done


## --- 
#source ./scripts/start.sh tensorflow 2.4.1 jupyter
