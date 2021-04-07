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

function uninstall_existing_components() {
    bar
    echo -e "\n \e[1m\e[31mUninstalling previous Installations...\e[0m\n"
    rm -rf .temp > /dev/null 2>&1
    sh ~/.ArduinoIDE/uninstall.sh > /dev/null 2>&1
    rm -rf ~/.ArduinoIDE > /dev/null 2>&1
    rm -rf ~/.arduino* > /dev/null 2>&1
    rm -rf ~/Arduino/libraries > /dev/null 2>&1
    echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function install_prerequisites() {
  bar
  echo -e "\n \e[1m\e[31mInstalling required System Packages...\e[0m\n"
  sudo apt update -qqq -y && sudo apt install wget -y -qqq
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
  mkdir ~/.ArduinoIDE
  FILE=$url
  FILE=$(basename "$FILE")
  tar -xf $FILE -C ~/.ArduinoIDE --strip-components=1
  cd ..
  echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function install_arduino_ide() {
  bar
  sudo adduser $USER dialout > /dev/null 2>&1
  echo -e "\n \e[1m\e[31mInstalling Arduino IDE v${arduino_ide_version}...\e[0m\n"
  sh ~/.ArduinoIDE/install.sh > /dev/null 2>&1
  echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

clean_up() {
  bar
  echo -e "\n \e[1m\e[31mRemoving Temporary Folders and Files...\e[0m\n"
  rm -rf .temp
  echo -e " -- DONE!\n"
  bar
  echo -e "\n \e[1m\e[32mHave fun with your Arduino UNO R3! :)\e[0m\n"
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

function set_permissions() {
 bar
 echo -e "\n \e[1m\e[31mSet Terminal Connection Permissions...\e[0m\n"
 sudo usermod -aG dialout $USER
 su -c 'exit' ${USER}
 sudo chmod 777 /dev/ttyACM0
 echo -e " -- DONE!\n"
}

## -------------------------------------------------------------------------------

function install_board() {
 bar
 echo -e "\n \e[1m\e[31mInstalling Core for Arduino UNO R3...\e[0m\n"
 arduino-cli core install arduino:avr
 echo -e "\n -- DONE!\n"
}

## -------------------------------------------------------------------------------

function install_libraries() {
  bar
  echo -e "\n \e[1m\e[31mInstalling Libraries...\e[0m\n"
  arduino-cli lib install EloquentArduino@1.1.8
  echo -e "\n -- DONE!\n"
}

## -------------------------------------------------------------------------------

function connect_and_test_board() {
 bar
 echo -e "\n \e[1m\e[31mConnecting an Testing Arduino UNO R3...\e[0m\n"
 boardpath=$(arduino-cli board list | grep arduino:avr:uno | cut -d' ' -f1)
 echo -e " \e[1mAttaching Board\e[0m\n ---------------"
 arduino-cli board attach ${boardpath} ~/.ArduinoIDE/examples/01.Basics/Blink/Blink.ino
 echo -e "\n \e[1mCompiling LED Blink test\e[0m\n ------------------------"
 arduino-cli compile ~/.ArduinoIDE/examples/01.Basics/Blink/Blink.ino
 echo -e " \e[1mUploading LED Blink test to Arduino\e[0m\n -----------------------------------"
 arduino-cli upload --verify ~/.ArduinoIDE/examples/01.Basics/Blink/Blink.ino
 echo -e "\n   \e[1m\e[5m  If your Arduino's LED is blinking, the test was successful !\e[0m"
 echo -e "\n -- DONE!\n"
}
