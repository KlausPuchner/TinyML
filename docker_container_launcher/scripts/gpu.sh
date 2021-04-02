#!/bin/bash

# Turn off script exit on failure
set +e

## -------------------------------------------------------------------------------

function check_gpu_driver() {
    if [ "$(nvidia-smi | grep -o NVIDIA-SMI)" ]
        then
            :
        else
            while true; do
                read -p $'\n \e[1m\e[31m No NVIDIA GPU Driver found! Install driver now (needs restart)? [y/n]:\e[0m ' opt
                if [ "$opt" = "y" ]; then
                    install_gpu_driver
                elif [ "$opt" = "n" ]; then
                    echo ""
                    break
                fi
            done
    fi
}

## -------------------------------------------------------------------------------

function check_gpu() {
  # If NVIDIA GPU exists...
    if [ "$(lshw -C display 2> /dev/null | grep -o NVIDIA)" ]; then
            # ...also check if NVIDIA driver is installed
            check_gpu_driver
    else
        :
    fi
}

## -------------------------------------------------------------------------------

function detect_gpu_driver() {
    if [ "$(nvidia-smi | grep -o NVIDIA-SMI)" ]
        then
            echo "--gpus all"
        else
            :
    fi
}

## -------------------------------------------------------------------------------

function detect_gpu() {
  # If NVIDIA GPU exists...
    if [ "$(lshw -C display 2> /dev/null | grep -o NVIDIA)" ]; then
            # ...also check if NVIDIA driver is installed
            detect_gpu_driver
    else
        :
    fi
}
## -------------------------------------------------------------------------------

function install_gpu_driver() {
    bar
    echo -e "\n \e[1m\e[31mInstalling NVIDIA GPU driver...\e[0m\n"
    echo -e "\e[1m Available Drivers:\n ------------------\e[0m"
    ubuntu-drivers devices
    echo -e "\n \e[1mInstall latest Driver:\n ---------------------\e[0m"
    sudo ubuntu-drivers autoinstall
    echo
}

## -------------------------------------------------------------------------------