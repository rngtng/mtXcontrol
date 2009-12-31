# mtXcontrol - a LED Matrix Editor -

*mtXcontrol* is an editor written in [Processing](http://processing.org) to easily create image sequences for several output devices containing multicolor LED matrix. By now, the [Rainbowduino controller](http://www.seeedstudio.com/depot/rainbowduino-led-driver-platform-plug-and-shine-p-371.html) and the
[Novation Launchpad](http://www.novationmusic.com/products/launchpad) are supported. Its generic API allows to add other in- and output
devices easily.

*mtXcontrol* Editor auto detects and connects to your device. Once connected, you can draw points, lines &amp; rows in different colors, create multiple frames and manipulate them. Add, delete, move, fill, copy &amp; paste of frames is supported. Play all frames by different speed, realtime update the device and save your work as image file. If supported (e.g. Rainbowduino), update the sequence on your device and run it standalone. One special feature is typing letters and numbers. Future versions aim to support multiple devices, different color depth and many more.

[Check out this short demo video](http://www.vimeo.com/6924030)

Download binaries and sources here: [github mtXControl Project](http://github.com/rngtng/mtXcontrol)

## Requirements:
* Mac/Win/Linux System running Java
* [Novation Launchpad](http://www.novationmusic.com/products/launchpad) OR
* [Rainbowduino + 8x8 RGB LED Matrix](http://www.seeedstudio.com/depot/rainbowduino-led-driver-platform-plug-and-shine-p-371.html)

If you're using Rainbowduino you'll need to upload firmware:

* [Arduino IDE](http://arduino.cc/en/Main/Software) 


optional:

* [Processing IDE](http://processing.org/download/)
* [Rainbowduino Processing Library](http://rngtng.github.com/rainbowduino)
* [Launchpad Processing Library](http://rngtng.github.com/launchpad)

## Launchpad HowTo:
Plug your Launchpad and start mtXcontrol. The device is auto detected - start drawing and pushing buttons!!

## Rainbowudino HowTo:
To use your Rainbowduino with mtXcontrol you have to upload the Firmware to your rainbowduino first. [See instruction here](http://www.rngtng.com/2009/06/25/rainbowduino-here-it-is-and-how-to-program-it).  The firmware makes use of the Rainbowduino.h Library to manipulate the Matrix easily. Make sure to put it into your Arduino Library. Connect your Rainbowduino via USB to your computer, upload firmware and you are ready to go - happy mtXcontrol drawing!

### Rainbowduino Step-by-Step Instructions:
1. Load the latest Arduino environment on the PC
2. Confirm the ability to upload a simple sketch to the Arduino, making sure to select the correct processor type
3. Upload the "blank" sketch to the Arduino so that it acts like a pass-through connection
4. connect the Rainbowduino to the Arduino as indicated in the [blog picture](http://www.rngtng.com/2009/06/25/rainbowduino-here-it-is-and-how-to-program-it) 
5. Using the Arduino IDE, load the firmware.pde sketch and then transfer it. The Arduino serves as the middle-man so that the microcontroller on the Rainbowduino can be reprogrammed. Important note is to change the processor type to 168 if you have a 328 Arduino.
6. A brand new Rainbowduino should stay blank. now go from displaying the multi-colored test pattern to all white LEDs.
7. Close the Arduino IDE. Load the latest Processing IDE (although similar in appearance, they are not the same). Remember to leave everything connected as displayed in the blog photo.
8. Load the mtXControl application and compile and run it. The display should go blank.
9. Use the application to design your animation. For a preview, switch to 'Device: Slave' mode (alt + ENTER) or second button form top, which displays your drawings in realtime on the Matrix.
10. Then save it to the Matrix.
11. Close the Processing IDE. Disconnect the USB cable from your PC to the Arduino and undo the connections between the Arduino and the Rainbowduino.
12. Power the Rainbowduino up by itself (either with an AC adaptor or a battery) and the animation should display.
(Big thanks to *Bob* putting [those steps together](http://www.seeedstudio.com/forum/viewtopic.php?f=11&t=435&start=10))


## Full list of Features:
* multiple Device support including auto detection
* Draw multicolor points, line and rows (4bit color support)
* Add, delete, clear, fill, *copy &amp; paste*, move frames
* *Draw letters and numbers*, Font configureable
* Save to &amp; load from *Bitmap file*
* Frame preview, easily navigate through
* Keyboard shortcut for each function

Rainbowduino:

  * Standalone Mode or realtime  Update
  * Upload and Download to Matrix *EEPROM* (mind: due to 256kb memory only up to 10 frames). 
  
Launchpad: 
  * full input support to choose color, frame & pixel


## Future ideas:
* Use compression to save more frames to EEPROM - Join discussion [here](http://stackoverflow.com/questions/1606102/arduino-lightweight-compression-algorithm-to-store-data-in-eeprom)
* Font configuration
* Support for multiple Rainbowduinos
* More colors (12bit Support)
* manual device selection
* UI & design updated, (help wanted!!!)
* XBee Support (does this require extra implementations?)
* autoload last sequence from file?
* sequence scripting
* sequence transitions, e.g. scrolling left/right, fading
* sequence backups
* more and updated Docs, screencasts, howtos
* testing!!

## Keyboard shortcuts:
* ENTER - switch between record/play Mode
* <left/right ARROW> - Frame forward/backward (Record Mode) or Speed (Play Mode)
* SPACE - Insert Frame after current Frame
* D - Delete Frame
* X - Clear frame
* F - fill frame
* C+<left/right ARROW> - select previous/next color
* C+ clicking the grid draw in fixed color

* command+S - Save to File (Bitmap)
* command+L - Load File (Bitmap OR text (.mtx))
* command+C - Copy Frame
* command+V - Paste Frame

* ctrl+<LETTER> - Insert this Letter/Number
* ctrl+<left/right ARROW> - Move Frame in direction

Rainbowduino:

* alt+ENTER - connect/disconnect
* alt+<left/right ARROW> - Adjust speed
* alt+ctrl+<left/right ARROW> - Adjust brightness 
* alt+L - load from EEPROM
* alt+S - save to EEPROM

## Launchpad input:
Top Buttons, Record Mode

* Arrow up - new frame
* Arrow down - delete frame
* Arrow left - previous frame
* Arrow right - next frame
* Session - copy frame
* User1 - insert frame
* User2 - color preview, hold to select
* Mixer - switch to play Mode

Top Buttons, Play Mode

* Arrow left - decrease speed
* Arrow right - increase speed
* Mixer - switch to record Mode

Right Buttons are turn into color chooser when User2 pressed. Blinking button indicates selected color, e.g. full red + full green = yellow. Pushing grid button selects color of pushed button.

## Changelog:

# v1.11
* updated minicolorbutton to be selected if current color
* removed color button
* added new shortcut 'C+<left/right ARROW>' - to select previous/next color
* added new shortcut 'C' to fix current drawing color when clicking the grid
* button action onClick which fixed load/save dialog hanging bug

Launchpad:

* updated button behaviours depended on play/record mode
* added speed control for play mode

# v1.1
* added launchpad support
* specified devices API to include future devices easily
* dynamic colorscheme
* device auto detection
* added icon
* minor bugfixes and deisgn updates
* new shortcut (C) to select color, use (X) to delete frame

Rainbowduino specific:

* moved to separate library, see [Rainbowduino Processing Library](http://rngtng.github.com/rainbowduino) for future updates
* added handshake and timeout for saver connection
* increased baud rate
* extended API for ping, buffer writing/reading and many more
* brightness control
* fixed save/load more than 8 frames bug

# v1.02
* save/load to images
* nice error message if not connected

# v1.01
* bugfixes

# v1.0
* initial release

## License
The MIT License

Copyright © 2009 RngTng, Tobias Bielohlawek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
