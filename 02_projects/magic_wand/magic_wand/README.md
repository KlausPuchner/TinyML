# **Project: Magic Wand**
The scope in this project is to test the IMUs capabilities by collecting movements from the Arduino.

## **Prerequisites**

- **Equipment**
    - A computer with Ubuntu 20.04 installed (an Nvdia GPU is recommended but not necessary)
    - The Arduino Tiny Machine Learning Kit (https://store.arduino.cc/tiny-machine-learning-kit )
- **Arduino Installation** (can be installed manually or via [install script](https://github.com/KlausPuchner/TinyML/tree/main/00_arduino_installer/nano-33-ble-sense))
    - Installed Arduino Nano 33 BLE Sense Board
    - Installed Arduino IDE
    - Installed Library (Harvard_TinyMLx, Tensorflow Lite Micro)
- **Docker Installation** (can be installed manually or via my [DockerLauncher tool](https://github.com/KlausPuchner/DockerLauncher.git))
    - Installed Docker
    - Installed Nvidia Container Toolkit
    - Nvidia GPU Driver Installation (optional - for faster training)

## **Arduino IDE Part (deploying the model)**
To be able to try out the model deploy the model directly to your Arduino by using my deployment script. This script will only work if you also used my [Arduino Nano 33 BLE Sense install script](https://github.com/KlausPuchner/TinyML/tree/main/00_arduino_installer/nano-33-ble-sense). You can start the script in your terminal simply starting it with `bash deploy.sh`.