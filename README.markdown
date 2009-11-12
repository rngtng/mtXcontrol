# mtXcontrol - a Rainbowduino Editor -

*mtXcontrol* is an editor written in [Processing](http://processing.org) to easily create image sequences for the [Rainbowduino controller](http://www.seeedstudio.com/depot/rainbowduino-led-driver-platform-plug-and-shine-p-371.html). The Rainbowduino is a 8x8 RGB LED driver controllr created by seeedstudio, based on the Arduino Project.

With *mtXcontrol* Editor you can draw points, lines &amp; rows in different colors, create multiple frames and manipulate them. Add, delete, move, fill, copy &amp; paste of frames is supported. Play all frames by different speed, realtime update the controller and save your work to file or upload it to Rainbowduino to make it standalone (mind: due to 256kb memory only up to 10 frames can be stored by now). A special feature is typing letters and numbers. Future versions aim to support multiple controllers and 

[Check out this short demo video](http://www.vimeo.com/6924030)


Download sources here: [github mtXControl Project](http://github.com/rngtng/mtXcontrol)

## Mini HowTo:
mtXcontrol consits of two parts:  One is the Editor program which you run on your computer, the other is the firmware you have to upload to your rainbowduino first. [See instruction here](http://www.rngtng.com/2009/06/25/rainbowduino-here-it-is-and-how-to-program-it).  The firmware makes use of the Rainbowduino.h Library to manipulate the Matrix easily. Make sure to put it into your Arduino Library. Connect your Rainbowduino via USB to your computer, upload firmware and you are ready to go - happy mtXcontrol drawing!


## Requirements
* Mac/Win/Linux System running Java
* Processing IDE, get it from [here](http://processing.org/download/)
* Arduino IDE, get it from [here](http://arduino.cc/en/Main/Software)
* Rainbowduino + 8x8 RGB LED Matrix, get it from [here](http://www.seeedstudio.com/depot/rainbowduino-led-driver-platform-plug-and-shine-p-371.html)


## Step-by-Step Instructions
1. Load the latest Arduino environment on the PC
2. Confirm the ability to upload a simple sketch to the Arduino, making sure to select the correct processor type
3. Upload the "blank" sketch to the Arduino so that it acts like a pass-through connection
4. connect the Rainbowduino to the Arduino as indicated in the [blog picture](http://www.rngtng.com/2009/06/25/rainbowduino-here-it-is-and-how-to-program-it) 
5. Using the Arduino IDE, load the firmware.pde sketch and then transfer it. The Arduino serves as the middle-man so that the microcontroller on the Rainbowduino can be reprogrammed. Important note is to change the processor type to 168 if you have a 328 Arduino.
6. A brand new Rainbowduino should now go from displaying the multi-colored test pattern to all white LEDs.
7. Close the Arduino IDE. Load the latest Processing IDE (although similar in appearance, they are not the same). Remember to leave everything connected as displayed in the blog photo.
8. Load the mtXControl application and compile and run it. The display should go blank.
9. Use the application to design your animation. For a preview, switch to 'Matrix: Slave' mode (alt + ENTER) or second button form top, which displays your drawings in realtime on the Matrix.
10. Then Save it to the Matrix.
11. Close the Processing IDE. Disconnect the USB cable from your PC to the Arduino and undo the connections between the Arduino and the Rainbowduino.
12. Power the Rainbowduino up by itself (either with an AC adaptor or a battery) and the animation should display.
(Big thanks to *Bob* putting [those steps together](http://www.seeedstudio.com/forum/viewtopic.php?f=11&t=435&start=10))

## Full list of Features:
* Draw multicolor points, line and rows  (8bit color support)
* Add, delete, clear, fill, *copy &amp; paste*, move frames
* *Draw letters and numbers*, Font configureable
* Save &amp; Load to File
* Upload and Download to Matrix *EEPROM* (mind: due to 256kb memory only up to 10 frames). 
* Frame preview, easily navigate through
* Standalone Mode or realtime Rainbowudino Update
* Keyboard shortcut for each function


## Future ideas:
* Use compression to save more frames to EEPROM - Join discussion [here](http://stackoverflow.com/questions/1606102/arduino-lightweight-compression-algorithm-to-store-data-in-eeprom)
* Font configuration
* Support for multiple Rainbowduinos
* Standard import/export file format
* Support other devices (launchpad/RG Matrix)
* More colors (12bit Support)
* XBee Support


## Keyboard shortcuts:
* ENTER - switch between record /place Mode
* <left/right ARROW> - Frame forward/backward (Record Mode) or Speed in Place Mode
* SPACE - Insert Frame after current Frame
* S - Save to File
* L - Load File
* D - Delete Frame
* C - Clear frame
* F - fill frame

* command+C - Copy Frame
* command+V - Paste Frame

* ctrl+<LETTER> - Insert this Letter/Number
* crtl+<left/right ARROW> - Move Frame in direction

* alt+ENTER - connect/disconnect to Rainbowduino
* alt+<left/right ARROW> - Adjust speed on Rainbowduino
* alt+L - download from Rainbowduino
* alt+S - upload from Rainbowduino


## Other
This project won the [seeedstudio carnival 2009](http://www.seeedstudio.com/forum/viewtopic.php?f=11&amp;t=397) See the [announcement and discussions](http://www.seeedstudio.com/forum/viewtopic.php?f=11&t=435&start=0) there.

## License
The MIT License

Copyright © 2009 RngTng, Tobias Bielohlawek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




