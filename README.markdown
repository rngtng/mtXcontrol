# mtXcontrol - a Rainbowduino Editor -

mtXcontrol is an editor written in Processing to easily create image sequences for the [Rainbowduino controller](http://www.seeedstudio.com/depot/rainbowduino-led-driver-platform-plug-and-shine-p-371.html). The Rainbowduino is a 8x8 RGB LED driver  controler created by seeedstudio, based on the Arduino Project.

With *mtXcontrol* Editor you can draw points, lines &amp; rows in different colors, create multiple frames and manipulate them. Add, delete, move, fill, copy &amp; paste of frames is supported. Play all frames by different speed, liveupdate the controller and save your work to file or upload it to Rainbowduino to make it standalone (mind: due to 256kb memory only up to 10 frames can be stored by now). A special feature is typing letters and numbers. Future versions aim to support multiple controllers and 

[Check out this short demo video](http://www.vimeo.com/6924030)


Download sources here: [github mtXControl Project](http://github.com/rngtng/mtXcontrol)

## Mini HowTo:
mtXcontrol consits of two parts:  One is the Editor program which you run on your computer, the other is the firmware you have to upload to your rainbowduino. [See instruction here](http://www.rngtng.com/2009/06/25/rainbowduino-here-it-is-and-how-to-program-it).  The firmware make use of the Rainbowduino.h Library to manioulate the Matrix easily. Connect your Rainbowduino via USB to your computer and you are ready to go - happy mtXcontrol drawing!

## Full list of Features:
* Draw multicolor points, line and rows  (8bit color support)
* Add, delete, clear, fill, <strong>copy &amp; paste</strong>, move frames
* <strong>Draw letters and numbers</strong>, Font configureable
* Save &amp; Load to File
* Upload and Download to Matrix <strong>EEPROM</strong> (mind: due to 256kb memory only up to 10 frames). 
* Frame preview, easily navigate through
* Standalone Mode or realtime Rainbowudino Update
* Keyboard shortcut for each function

## Future ideas:
* Use compression to save more frames to EEPROM (e.g. Huffman?)
* Font configuration
* Support for multiple Rainbowduinos
* Standart import/export file format
* Support other devices
* More colors 

## Keyboard shortcuts:
ENTER - switch between record /place Mode
<left/right ARROW> - Frame forward/backward (Record Mode) or Speed in Place Mode
SPACE - Insert Frame after current Frame
S - Save to File
L - Load File
D - Delete Frame
C - Clear frame
F - fill frame

command+C - Copy Frame
command+V - Paste Frame

ctrl+<LETTER> - Insert this Letter/Number
crtl+<left/right ARROW> - Move Frame in direction

alt+ENTER - connect/disconnect to Rainbowduino
alt+<left/right ARROW> - Adjust speed on Rainbowduino
alt+L - download from Rainbowduino
alt+S - upload from Rainbowduino


This project is part of the [seeedstudio carnival 2009](http://www.seeedstudio.com/forum/viewtopic.php?f=11&amp;t=397)



