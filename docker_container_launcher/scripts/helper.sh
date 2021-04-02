#!/bin/bash

# Turn off script exit on failure
set +e

## ---------- Helper Functions ----------

function bar() {
  echo "==============================================================================="
}

function pause() {
  read -p "$*"
}

function get_ubuntu_codename() {
  lsb_release -a 2> /dev/null | grep Codename | cut -f2
}

function generate_url() {
  sleep 3

  # Get host ip address
  ipaddress=$(hostname -I | sed -u 's/\ .*//')

  # Get random port
  port=$(docker ps | grep $1 | sed -u 's/.*0.0.0.0://g' | sed -u 's/->.*//g')

  # Build complete string
  address=$(echo "http://${ipaddress}:${port}")
  echo $address
}

function get_uuid() {
  echo $(uuidgen)
}

function get_ctrlc_text() {
  echo -e "\n\e[1m ==> Press Ctrl + C twice to shutdown/terminate Application\e[0m"
}