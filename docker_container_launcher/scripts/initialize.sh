#!/bin/bash

# Turn off script exit on failure
set +e

## -------------------------------------------------------------------------------

function initialize() {
    check_docker_installation
    check_gpu
}