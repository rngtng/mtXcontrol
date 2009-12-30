#!/bin/sh

rm ~/Desktop/latest_mtXcontrol_and_firmware_linux.zip
mkdir application.linux/firmware
cp ~/Sites/java/rainbowduino/firmware/*.* application.linux/firmware
zip -x .DS_Store -r ~/Desktop/latest_mtXcontrol_and_firmware_linux.zip application.linux/

rm ~/Desktop/latest_mtXcontrol_and_firmware_macosx.zip
mkdir application.macosx/firmware
cp -f sketch.icns application.macosx/mtXcontrol.app/Contents/Resources/sketch.icns
cp ~/Sites/java/rainbowduino/firmware/*.* application.macosx/firmware
zip -x .DS_Store -r ~/Desktop/latest_mtXcontrol_and_firmware_macosx.zip application.macosx/

rm ~/Desktop/latest_mtXcontrol_and_firmware_windows.zip
mkdir application.windows/firmware
cp ~/Sites/java/rainbowduino/firmware/*.* application.windows/firmware
zip -x .DS_Store -r ~/Desktop/latest_mtXcontrol_and_firmware_windows.zip application.windows/