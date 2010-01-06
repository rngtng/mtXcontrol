#!/bin/sh

rm ~/Desktop/latest_mtXcontrol_and_firmware_linux.zip
# copy firmware
mkdir application.linux/firmware
cp ~/Sites/java/rainbowduino/firmware/*.* application.linux/firmware
#rename
mv application.linux mtXcontrol
zip -x .DS_Store -r ~/Desktop/latest_mtXcontrol_and_firmware_linux.zip mtXcontrol/
rm -rf mtXcontrol

#only 32 Bit version by now
rm ~/Desktop/latest_mtXcontrol_and_firmware_macosx.zip
#patch Mac Os X file to use java 1.6
mv application.macosx/mtXcontrol.app/Contents/Info.plist application.macosx/mtXcontrol.app/Contents/Info_old.plist
sed 's/1\.5/1\.6/g' application.macosx/mtXcontrol.app/Contents/Info_old.plist > application.macosx/mtXcontrol.app/Contents/Info.plist
#copy icon
cp -f sketch.icns application.macosx/mtXcontrol.app/Contents/Resources/sketch.icns
# copy firmware
mkdir application.macosx/firmware
cp ~/Sites/java/rainbowduino/firmware/*.* application.macosx/firmware
#rename
mv application.macosx mtXcontrol
zip -x .DS_Store -r ~/Desktop/latest_mtXcontrol_and_firmware_macosx.zip mtXcontrol/
rm -rf mtXcontrol

rm ~/Desktop/latest_mtXcontrol_and_firmware_windows.zip
# copy firmware
mkdir application.windows/firmware
cp ~/Sites/java/rainbowduino/firmware/*.* application.windows/firmware
#rename
mv application.windows mtXcontrol
zip -x .DS_Store -r ~/Desktop/latest_mtXcontrol_and_firmware_windows.zip mtXcontrol/
rm -rf mtXcontrol