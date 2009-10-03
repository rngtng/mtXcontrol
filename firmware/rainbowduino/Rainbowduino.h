/*
RAINBOWDUINO.h - A driver to run Seeedstudio 8x8 RBG LED Matrix
Based on Rainbow.h by Seedstudio.com -> http://www.seeedstudio.com/depot/rainbowduino-led-driver-platform-plug-and-shine-p-371.html
Copyright (c) 2009 Tobias Bielohlawek

*/

#ifndef RAINBOWDUINO_h
#define RAINBOWDUINO_h

// include types & constants of Wiring core API
#include <WProgram.h>

//=============================================
//MBI5168
#define SH_DIR   DDRC
#define SH_PORT   PORTC

#define SH_BIT_SDI   0x01
#define SH_BIT_CLK   0x02

#define SH_BIT_LE    0x04
#define SH_BIT_OE    0x08
//============================================
#define clk_rising  {SH_PORT &= ~SH_BIT_CLK; SH_PORT |= SH_BIT_CLK; }
#define le_high     {SH_PORT |= SH_BIT_LE; }
#define le_low      {SH_PORT &= ~SH_BIT_LE; }
#define enable_oe   {SH_PORT &= ~SH_BIT_OE; }
#define disable_oe  {SH_PORT |= SH_BIT_OE; }

#define shift_data_1     {SH_PORT |= SH_BIT_SDI;}
#define shift_data_0     {SH_PORT &= ~SH_BIT_SDI;}

class Rainbowduino {

public:
  Rainbowduino();
  void set_row(byte line, byte level, byte r, byte b, byte g);
  void set_color(byte c);
  void open_line(byte line);
};

#endif	//RAINBOWDUINO.h



