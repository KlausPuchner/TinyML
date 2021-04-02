# **Project: Deploying a keyword spotting model with two signal words**
The scope in this project is to train and quantize a Tensorflow Lite Micro model and deploy it to the Arduino Nano 33 BLE Sense. The model should enable the Arduino to recognize and to respond to the two keywords "stop" and "go" by blinking a particular led (stop = red, go = green).

For this project, we do not use Google Colab. We use a locally deployed, dockerized jupyter notebook with Tensorflow 1.15.5. You can either use my launcher tool (<span style="color:red">**TODO: LINK**</span>) for this or you can also install the prerequisites on your own.

## **Prerequisites**

- **Equipment**
    - A computer with Ubuntu 20.04 installed (an Nvdia GPU is recommenced but not necessary)
    - The Arduino Tiny Machine Learning Kit (https://store.arduino.cc/tiny-machine-learning-kit  - **Affiliate Link?**)
- **Arduino Installation** (can be installed manually or via Script, see xxxx)
    - Installed Arduino Nano 33 BLE Sense Board
    - Installed Arduino IDE
    - Installed Library (Harvard_TinyMLx)
- **Docker Installation** (can be installed manually or via Script, see xxx)
    - Installed Docker
    - Installed Nvidia Container Toolkit
    - Nvidia GPU Driver Installation (optional - for faster training)

## **Jupyter Notebook Part (training the model)**
The Jupyter notebook guides you through the process of training a KWS model. IT is based on the Colabs which from Tensorflows micro_speech example as well as the HarvardX 3_5_18_TrainingKeywordSpotting.ipynb and 4_5_16_KWS_PretrainedModel from the TinyML Specialization on edX. To get started start a jupyter notebook with Tensorflow 1.15.5 and open the ipynb Notebook **TrainKeywordSpottingModel2words.ipynb** (<span style="color:red">**TODO: LINK**</span>).

Roughly summarized the notebook contains the following steps:

1. Start a jupyter notebook with Tensorflow 1.15.5 backend and open the ipynb Notebook
2. Install prerequisites, import packages and configure the model (choose which keywords you want to train).
3. Train model based on Tensorflow's micro speech.
4. Generate model, convert it into a quantized Tensorflow Lite Micro model and compare its accuracy with its non-quantized counterpart.
5. (<span style="color:red">**TODO**</span>): Testing the model with your own recording
6. Generate a Tensorflow Lite Micro model


## **Arduino IDE Part (deploying the model)**
To be able to try out the model without having to follow the manual steps explained in this section, you can deploy the model directly to your Arduino by using my deployment script (<span style="color:red">**TODO: LINK**</span>): URL to Script). This script will only work if you also used my Arduino Nano 33 BLE Sense install script (<span style="color:red">**TODO: LINK**</span>): URL to Script). You can start the script in your terminal simply starting it with *"bash deploy.sh"*.

### **Step 1**
In the Arduino IDE, open *File → Examples → Harvard_TinyMLx → micro_speech* look for and open the **micro_features_model.cpp** file.
Two things need to be done here:

1. Copy the column with the hex values from the downloaded or printed model from the previous step into the **micro_features_model.cpp** file and overwrite the existing hex values (**Attention:** only copy the hex data inside the curved brackets {}!!!).

2. Again from the previously downloaded or printed model copy the number behind *g_model_len* into **micro_features_model.cpp** and overwrite the existing number

3. Save the changes into a folder of your choice.

### **Step 2**
Open the **micro_features_micro_model_settings.h** file and locate the **kCategoryCount** value (make sure it states *constexpr int kCategoryCount = 4;*). If you find another number, please replace it with the number 4. Why does it have to be four? The micro_speech model has to basic classes ("silence" and "unknown") while additional keywords have to be added (in our case "stop" and "go"), which leads to an overall category count of 2 + 2 = 4. Save changes.

### **Step 3**
Open the **micro_features_micro_model_settings.cpp** file and locate the **const char* kCategoryLabels[kCategoryCount]** array statement. Replace *"yes"* with *"stop"* and *"no"* with *"go"*. Save changes.

### **Step 4**
Open the **arduino_command_responder.cpp** file, **locate** and **replace**...

1. ...the ***if (found_command[0] == 'y')*** with ***if (found_command[0] == 'g')***
2. ...the ***if (found_command[0] == 'n')*** with ***if (found_command[0] == 's')***

Save changes.

### **Step 5**
Deploy the model with the following steps:

1. Ensure the Arduino is connected
2. In the Arduino IDE Menu, select the Arduino Nano 33 BLE in *Tools → Board: <"whateverboardyousee"> → Arduino Mbed OS Boards (nRF52840) → Arduino Nano 33 BLE*
3. In the Arduino IDE Menu, select the Port your Arduino is connected to in *Tools → Port: <Current Port: "whateverport (whateverboardyousee)"> → <ttyACM0 (Arduino Nano 33 BLE)*
4. In the Arduino IDE Menu, select *Sketch → Upload*. You can see the progress in the shell window: If the compiling and uploading is successfull, you should get a message like *"Done in x.xxx seconds"*. You should now have a fully functional keyword spotting model.
