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

#define NUM_ROWS 24 // 3 BYTES  per ROW

class Rainbowduino {

public:
  byte frame_buffer[24*10]; // [FRAME_BUFFER_SIZE]; //size of EEPROM -> to read faster??

  byte current_frame_nr;
  word current_frame_offset;
  
  volatile byte current_row;
  byte num_frames;
  byte num_rows;
  
  word off;
  
  Rainbowduino(byte set_num_frames = 1);
  void reset();
  void set_frame(byte frame_nr, byte* data);
  void set_frame_nr(byte frame_nr);
  void set_frame_row(byte frame_nr, byte row, byte data);  
  void set_current_frame_row(byte row, byte data); 
  void next_frame();
  int  nframes();
  void draw();
    
private:
  void draw_row(byte row, byte level, byte r, byte b, byte g);
  void draw_color(byte c);
  void enable_row(byte row);
};

#endif	//RAINBOWDUINO.h



