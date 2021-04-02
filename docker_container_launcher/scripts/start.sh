#!/bin/bash

# Turn off script exit on failure
set +e

## -------------------------------------------------------------------------------
function start_tf2_jupyter() {
    tag_framework=${1}
    tag_framework_version=${2}

    if [ "$(detect_gpu)" = "--gpus all" ]; then
        tag_gpu="-gpu"
    else
        tag_gpu=""
    fi

    # Build image name
    imagetag="tensorflow/${tag_framework}:${tag_framework_version}${tag_gpu}-jupyter"

    # Set unique container name
    containername=$(get_uuid)

    # 
    if [ "$3" = "throwaway" ]; then
        startparam="--rm"
    else
        startparam=""
    fi

    clear

    echo

    header

    echo

    get_ctrlc_text

    docker run --name $containername ${startparam} -it $(detect_gpu) \
        -p 8888 -p 6006-6015:6006-6015 \
        -v ~/dockervolume/:/tf/notebooks \
        -v $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent \
        $imagetag \
        | grep --line-buffered '     or http://127.0.0.1' | head -1 \
        | { token=$(sed -u 's/.*\///'); address=$(generate_url $containername); url="${address}/${token}";\
        printf "\e[1m\e[94m ==> \e]8;;$url\e\\Click here to open Jupyter in your Browser\e]8;;\e\\ \e[0m"; }

    echo -e "\n"
}

function start_tf1_jupyter() {
    tag_framework=${1}
    tag_framework_version=${2}

    if [ "$(detect_gpu)" = "--gpus all" ]; then
        tag_gpu="-gpu-py3"
    else
        tag_gpu=""
    fi

    # Build image name
    imagetag="tensorflow/${tag_framework}:${tag_framework_version}${tag_gpu}-jupyter"

    # Set unique container name
    containername=$(get_uuid)

    # 
    if [ "$3" = "throwaway" ]; then
        startparam="--rm"
    else
        startparam=""
    fi

    clear

    echo

    get_ctrlc_text

    docker run --name $containername ${startparam} -it $(detect_gpu) \
        -p 8888 -p 6006-6015:6006-6015 \
        -v ~/dockervolume/:/tf/notebooks \
        -v $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent \
        $imagetag \
        | grep --line-buffered '     or http://127.0.0.1' | head -1 \
        | { token=$(sed -u 's/.*\///'); address=$(generate_url $containername); url="${address}/${token}";\
        printf "\e[1m\e[94m ==> \e]8;;$url\e\\Click here to open Jupyter in your Browser\e]8;;\e\\ \e[0m"; }

    echo -e "\n"
}

# docker run --gpus all --rm -it -e PASSWORD=mu -p 8787:8787 rocker/ml-verse:4.0.4-cuda11.1