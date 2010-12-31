# cubeXcontrol - a LED Matrix Editor -

*cubeXcontrol* is an editor written in [Processing](http://processing.org) to easily create image sequences for Rainbow 4x4x4 RGB LED Cube. 

*cubeXcontrol* Editor auto detects and connects to your device. Once connected, you can draw points, lines &amp; rows in different colors, create multiple frames and manipulate them. Add, delete, move, fill, copy &amp; paste of frames is supported. Play all frames by different speed, realtime update the device and save your work as image file. If supported (e.g. Rainbowduino), update the sequence on your device and run it standalone. One special feature is typing letters and numbers. Future versions aim to support multiple devices, different color depth and many more.

[Check out this short demo video](http://vimeo.com/18300458)

Download binaries and sources here: [github cubeXcontrol Project](https://github.com/rngtng/mtXcontrol/tree/cubeXcontrol)

## Requirements:
* Mac/Win/Linux System running Java
* [Rainbowduino + Rainbow Cube Kit](http://www.seeedstudio.com/depot/rainbow-cube-kit-rgb-4x4x4-rainbowduino-compatible-p-596.html)

If you're using Rainbowduino you'll need to upload firmware:

* [Arduino IDE](http://arduino.cc/en/Main/Software) 


optional:

* [Processing IDE](http://processing.org/download/)
* [Rainbowduino Processing Library](http://rngtng.github.com/rainbowduino)


## Rainbowudino HowTo:
To use your Rainbowduino with cubeXcontrol you have to upload the Firmware to your rainbowduino first. [See instruction here](http://www.rngtng.com/2009/06/25/rainbowduino-here-it-is-and-how-to-program-it).  The firmware makes use of the Rainbowduino.h Library to manipulate the Matrix easily. Make sure to put it into your Arduino Library. Connect your Rainbowduino via USB to your computer, upload firmware and you are ready to go - happy cubeXcontrol drawing!

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

* Draw multicolor points, line and rows (4bit color support)
* Add, delete, clear, fill, *copy &amp; paste*, move frames
* *Draw letters and numbers*, Font configureable
* Save to &amp; load from *Bitmap file*
* Frame preview, easily navigate through
* Keyboard shortcut for each function
  

## Future ideas:
find a universal approach to tie in with mtXcontrol for having just one version to control
them all
more see mtXcontrol,

# v1.0
* initial release

## License
The MIT License

Copyright © 2009 RngTng, Tobias Bielohlawek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
