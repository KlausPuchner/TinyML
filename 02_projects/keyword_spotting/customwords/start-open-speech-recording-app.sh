#!/bin/bash

set +e

clear
echo
echo "Starting Open Speech Recording App..."
echo "Source: https://github.com/tinyMLx/appendix/blob/main/OpenSpeechRecordingLocal.md"
echo
## --- Install and upgrade PIP ---
sudo apt-get update -qqq
sudo apt-get install -qqq -y python3-pip
python3 -m pip install --upgrade --quiet pip

## --- Install Virtualenv Package ---
python3 -m pip install --upgrade --quiet virtualenv

## --- Create Virtual Environment ---
mkdir ~/venv/
virtualenv  ~/venv/open-speech-recording

## --- Activate the virtual Environment ---
source ~/venv/open-speech-recording/bin/activate

## --- Install and upgrade git ---
sudo apt-get update -qqq
sudo apt-get install -qqq -y git

## --- Install Open-Speech-Recording App ---
cd ~/venv/open-speech-recording
git clone https://github.com/tinyMLx/open-speech-recording.git
python3 -m pip install --upgrade --quiet --no-cache-dir pip flask

## --- Start Open-Speech-Recording App ---
cd open-speech-recording
export FLASK_APP=main.py
python3 -m flask run

## --- Shorten filenames to function with Pete Warden's Tool ---
for filename in *.ogg; do
	[ -e "$filename" ] || continue
		echo $filename
		strarr=(${filename//_/ })
		newname="${strarr[0]}_${strarr[2]}"
		echo $newname
		mv $filename $newname
done


## --- Move Sound Files ---
mkdir ~/dockervolume/audiofiles
mv *.ogg ~/dockervolume/audiofiles

## --- Deactivate the virtual Environment ---
deactivate

## --- Remove Application ---
rm -rf ~/venv/open-speech-recording
