# **Project: Magic Wand with Custom Spell**
The scope in this project is to test the IMUs capabilities by collecting movements from the Arduino and train a model with own spells (movements).

For this project, we do not use Google Colab. We use a locally deployed, dockerized jupyter notebook with Tensorflow 2.4.1. You can either use my DockerLauncher tool for this or you can also install the prerequisites on your own.

## **Prerequisites**

- **Equipment**
    - A computer with Ubuntu 20.04 installed (an Nvdia GPU is recommended but not necessary)
    - The Arduino Tiny Machine Learning Kit (https://store.arduino.cc/tiny-machine-learning-kit )
    - An up-to-date version of Chrome Browser to [collect and label your data](https://tinymlx.org/magic_wand) (activate *Experimental Web Platform features* by entering `chrome://flags/#enable-experimental-web-platform-features` into your Chrome browser)
- **Arduino Installation** (can be installed manually or via [install script](https://github.com/KlausPuchner/TinyML/tree/main/00_arduino_installer/nano-33-ble-sense))
    - Installed Arduino Nano 33 BLE Sense Board
    - Installed Arduino IDE
    - Installed Library (Harvard_TinyMLx, Tensorflow Lite Micro)
- **Docker Installation** (can be installed manually or via my [DockerLauncher tool](https://github.com/KlausPuchner/DockerLauncher.git))
    - Installed Docker
    - Installed Nvidia Container Toolkit
    - Nvidia GPU Driver Installation (optional - for faster training)

## **Jupyter Notebook Part (training the model)**
The Jupyter notebook guides you through the process of training a KWS model. It is based on the Colabs which from Tensorflows micro_speech example as well as the HarvardX 4-8-11-CustomMagicWand from the TinyML Specialization on edX. To get started start a jupyter notebook with Tensorflow 2.4.1 installed and open the ipynb Notebook [**MagicWandCustom.ipynb**](https://github.com/KlausPuchner/TinyML/blob/main/02_projects/magic_wand/magic_wand_custom/MagicWandCustom.ipynb).

Roughly summarized the notebook contains the following steps:

1. Start a jupyter notebook with Tensorflow 2.4.1 backend and open the ipynb Notebook
2. Install prerequisites, import packages and configure the model (choose which keywords you want to train).
3. Train model based on HarvardX's magic wand example.
4. Generate model, convert it into a quantized Tensorflow Lite Micro model and compare its accuracy with its non-quantized counterpart.
5. Generate a Tensorflow Lite Micro model

## **Arduino IDE Part (deploying the model)**
To be able to try out the model deploy the model directly to your Arduino by using my deployment script. This script will only work if you also used my [Arduino Nano 33 BLE Sense install script](https://github.com/KlausPuchner/TinyML/tree/main/00_arduino_installer/nano-33-ble-sense). You can start the script in your terminal simply starting it with `bash deploy.sh`.

### **Step 1**
In the Arduino IDE, open *File → Examples → Harvard_TinyMLx → magic_wand* look for and open the **magic_wand_model_data.cpp** file.
Two things need to be done here:

1. Copy the column with the hex values from the downloaded or printed model from the previous step into the **magic_wand_model_data.cpp** file and overwrite the existing hex values (**Attention:** only copy the hex data inside the curved brackets {} !!!).

2. Again from the previously downloaded or printed model copy the number behind *`g_model_len`* into **magic_wand_model_data.cpp** and overwrite the existing number

3. Save the changes into a folder of your choice.

### **Step 2**
In **magic_wand_custom.ino**, go to line 58/59 and make sure to update them according to the number and kind of gestures in the dataset (in our example we use 0 - 9 ascending):

`constexpr int label_count = 10;`
`const char* labels[label_count] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};`

Save changes.

### **Step 3**
Deploy the model with the following steps:

1. Ensure the Arduino is connected
2. In the Arduino IDE Menu, select the Arduino Nano 33 BLE in *Tools → Board: <"whateverboardyousee"> → Arduino Mbed OS Boards (nRF52840) → Arduino Nano 33 BLE*
3. In the Arduino IDE Menu, select the Port your Arduino is connected to in *Tools → Port: <Current Port: "whateverport (whateverboardyousee)"> → <ttyACM0 (Arduino Nano 33 BLE)*
4. In the Arduino IDE Menu, select *Sketch → Upload*. You can see the progress in the shell window: If the compiling and uploading is successfull, you should get a message like *"Done in x.xxx seconds"*. You should now have a fully functional keyword spotting model.

