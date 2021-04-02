#!/bin/bash

## --- Importing Functions and Parameters ---

source ./scripts/parameters.sh
source ./scripts/functions.sh

## ---------- Start of actual Script ----------

show_script_header

check_connections

uninstall_existing_components

install_prerequisites

make_tempdir

download_arduino_ide

extract_arduino_ide

install_arduino_ide

download_arduino_cli

install_arduino_cli

install_board

install_libraries

connect_and_test_board

clean_up

