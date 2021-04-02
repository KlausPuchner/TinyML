#!/bin/bash

## --- Importing Functions and Parameters ---

source ./deployment/parameters.sh
source ./deployment/functions.sh

## ---------- Start of Main Script ----------

show_script_header

check_connections

connect_board_and_deploy_script

wrap_up

