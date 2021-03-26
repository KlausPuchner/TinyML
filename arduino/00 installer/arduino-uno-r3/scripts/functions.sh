#!/bin/bash

## ---------- Helper Functions ----------

function bar(){
 echo "====================================================================="
}

## -------------------------------------------------------------------------------

function show_script_header() {
  clear
  echo
  bar
  echo
  echo -e "                   \e[1m\e[32mARDUINO UNO R3 Install Script\e[0m"
  echo -e "                      Build Date (${builddate})\n"
  bar
}

## -------------------------------------------------------------------------------

function pause() {
  read -s -n 1 -p " Press any key to continue..."
  echo -e "\n"
}

## -------------------------------------------------------------------------------

function check_connections() {
  echo -e "\n \e[5m\e[1m  Please Connect your Arduino to your PC via USB Cable !\e[0m\n"
  bar
  echo -e "\n \e[1m\e[31mScanning for Connection with Arduino...\e[0m\n"
while true
do
  sleep 2
  connections=$(ls -l /dev/ttyACM* 2> /dev/null)
  devices=$(lsusb | grep Arduino )
  if [ $? -eq 0 ]; then
    echo -e " \e[1mFound the following connections:\e[0m\n --------------------------------\n${connections}\n"
    echo -e " \e[1mFound the following devices:\e[0m\n --------------------------------\n${devices}\n"  
    sleep 5
    echo -e " -- DONE!\n" 
    break
  fi
done
}

## -------------------------------------------------------------------------------

function install_prerequisites() {
  bar
  echo -e "\n \e[1m\e[31mInstalling required System Packages...\e[0m\n"
  sudo apt update -qq -y && sudo apt install wget -y -qq
  echo -e "\n -- DONE!\n"
}

## -------------------------------------------------------------------------------

function make_tempdir() {
  bar
  echo -e "\n \e[1m\e[31mCreating Temporary Folder...\e[0m\n"
  rm -rf .temp
  mkdir .temp
  echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function download_arduino_ide() {
  if [ $(uname -m) == 'x86_64' ]; then
    osarch="64"
  else
    osarch="32"
  fi
  url="https://downloads.arduino.cc/arduino-${arduino_ide_version}-linux${osarch}.tar.xz"
  FILE=$url
  FILE=$(basename "$FILE")
  /bin/rm -f $FILE
  bar
  echo -e "\n \e[1m\e[31mDownloading Arduino IDE v${arduino_ide_version} Installation File...\e[0m\n"
  wget --no-check-certificate --quiet --directory-prefix=.temp $url
  echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function extract_arduino_ide() {
  bar
  echo -e "\n \e[1m\e[31mExtracting Arduino IDE v${arduino_ide_version} Installation Files...\e[0m\n"
  cd .temp
  rm -rf ~/Arduino
  mkdir ~/Arduino
  FILE=$url
  FILE=$(basename "$FILE")
  tar -xf $FILE -C ~/Arduino --strip-components=1
  cd ..
  echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function install_arduino_ide() {
  bar
  sudo adduser $USER dialout > /dev/null 2>&1
  echo -e "\n \e[1m\e[31mInstalling Arduino IDE v${arduino_ide_version}...\e[0m\n"
  ~/Arduino/install.sh > /dev/null 2>&1
  echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

clean_up() {
  bar
  echo -e "\n \e[1m\e[31mRemoving Temporary Folders and Files...\e[0m\n"
  rm -rf .temp
  echo -e " -- DONE!\n"
  bar
  echo -e "\n \e[1m\e[32mHave fun with your Arduino! :)\e[0m\n"
}

## -------------------------------------------------------------------------------

function download_arduino_cli() {
  if [ $(uname -m) == 'x86_64' ]; then
    osarch="64"
  else
    osarch="32"
  fi
  url="https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_${osarch}bit.tar.gz"
  FILE=$url
  FILE=$(basename "$FILE")
  /bin/rm -f $FILE
  bar
  echo -e "\n \e[1m\e[31mDownloading latest Arduino CLI Installation File...\e[0m\n"
  wget --no-check-certificate --quiet --directory-prefix=.temp $url
  echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function install_arduino_cli() {
  bar
  echo -e "\n \e[1m\e[31mInstalling latest Arduino CLI...\e[0m\n"
  cd .temp
  FILE=$url
  FILE=$(basename "$FILE")
  sudo tar -xf $FILE -C /usr/bin
  arduino_cli_version=$(arduino-cli version)
  arduino-cli core update-index
  arduino-cli lib update-index
  cd ..
  echo -e "\n -- DONE!\n"
}

## -------------------------------------------------------------------------------

function install_libraries() {
  bar
  echo -e "\n \e[1m\e[31mInstalling Libraries...\e[0m\n"
  #arduino-cli lib install Arduino_TensorFlowLite@2.4.0-ALPHA
  #arduino-cli lib install Harvard_TinyMLx@1.0.1-Alpha
  #arduino-cli lib install Arduino_LSM9DS1@1.1.0
  #arduino-cli lib install ArduinoBLE@1.1.3
  echo -e "\n -- DONE!\n"
}

