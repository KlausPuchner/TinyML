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
  echo -e "             \e[1m\e[32mMicro Speech 2 Word Deployment Script\e[0m"
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
      echo -e " \e[1mFound the following devices:\e[0m\n ----------------------------\n${devices}\n"  
      sleep 5
      echo -e " -- DONE!\n"
      break
    fi
done
}

## -------------------------------------------------------------------------------

wrap_up() {
  bar
  echo -e "\n \e[1m\e[32mHave fun with your deployed model! :)\e[0m\n"
}

## -------------------------------------------------------------------------------

function install_libraries() {
 bar
 echo -e "\n \e[1m\e[31mInstalling Libraries...\e[0m\n"
 arduino-cli lib install Arduino_TensorFlowLite@2.4.0-ALPHA
 arduino-cli lib install Harvard_TinyMLx@1.0.1-Alpha
 arduino-cli lib install Arduino_LSM9DS1@1.1.0
 arduino-cli lib install ArduinoBLE@1.1.3
 arduino-cli lib install EloquentArduino@1.1.8
 echo -e "\n -- DONE!\n"
}

## -------------------------------------------------------------------------------

function connect_board_and_deploy_script() {
 bar
 echo -e "\n \e[1m\e[31mConnecting Arduino Nano 33 BLE Sense and deploying model...\e[0m\n"
 boardpath=$(arduino-cli board list | grep arduino:mbed:nano33ble | cut -d' ' -f1)
 echo -e " \e[1mAttaching Board\e[0m\n ---------------"
 arduino-cli board attach ${boardpath} ./deployment/micro_speech_4words/micro_speech_4words.ino
 echo -e "\n \e[1mCompiling Model\e[0m\n ------------------------"
 arduino-cli compile ./deployment/micro_speech_4words/micro_speech_4words.ino
 echo -e " \e[1mUploading Model to Arduino\e[0m\n -----------------------------------"
 arduino-cli upload --verify ./deployment/micro_speech_4words/micro_speech_4words.ino
 echo -e "\n -- DONE!\n"
}

