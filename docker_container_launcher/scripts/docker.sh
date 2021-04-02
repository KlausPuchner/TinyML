#!/bin/bash

# Turn off script exit on failure
set +e

## -------------------------------------------------------------------------------

function install_docker() {
    bar
    echo -e "\n \e[1m\e[31mInstalling Docker...\e[0m\n"
    sudo apt update -qq
    sudo apt install -y -qq apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(get_ubuntu_codename) stable" 2>&1 > /dev/null | grep -v '^gpg' 
    sudo apt update -qq
    sudo apt install -y -qq docker-ce
    sudo usermod -aG docker ${USER}
    su -c 'exit' ${USER}
    test_docker
    echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function test_docker() {
    echo -e "\n \e[1m\e[31mTesting if Docker works...\e[0m"
    docker run hello-world
}

## -------------------------------------------------------------------------------

function get_docker_status() {
    sudo systemctl status docker
}

## -------------------------------------------------------------------------------

function install_nvidia_container_toolkit() {
    bar
    echo -e "\n \e[1m\e[31mInstalling Nvidia Container Runtime...\e[0m\n"
    sudo apt update -qq
    sudo apt install -qq -y curl
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 2>&1 > /dev/null | grep -v '^gpg' \
    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt update -qq
    sudo apt install -qq -y nvidia-docker2
    sudo systemctl restart docker
    test_nvidia_container_toolkit
    echo -e "\n --DONE!\n"
}

## -------------------------------------------------------------------------------

function test_nvidia_container_toolkit() {
    echo -e "\n \e[1m\e[31mTesting if GPU is handed over to Docker Container...\e[0m\n"
    sudo docker run --rm $(detect_gpu) nvidia/cuda:11.0-base nvidia-smi
}

## -------------------------------------------------------------------------------

function check_docker_installation() {
    if [ -x "$(command -v docker)" ]; then
        :
    else
        install_docker
        check_nvidia_container_toolkit
    fi
}

function check_nvidia_container_toolkit() {
    if [ -x "$(which nvidia-docker)" ]; then
        :
    else
        install_nvidia_container_toolkit
    fi
}

## -------------------------------------------------------------------------------
