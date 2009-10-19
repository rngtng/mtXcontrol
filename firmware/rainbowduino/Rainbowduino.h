/*
 * Rainbowduino.h version 1.02 - A driver to run Seeedstudio 8x8 RBG LED Matrix
 * Based on Rainbow.h by Seedstudio.com -> http://www.seeedstudio.com/depot/rainbowduino-led-driver-platform-plug-and-shine-p-371.html
 * Copyright (c) 2009 Tobias Bielohlawek -> http://www.rngtng.com
 *
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

#define NUM_LINES 8
#define NUM_ROWS 24 // 3 BYTES per ROW  x 8 Lines
#define MAX_NUM_FRAMES 10 // 3 BYTES  per ROW

#define NUM_LEVEL 16 

class Rainbowduino {

public:
  byte num_frames;
  byte max_num_frames;
  byte num_rows;

  byte frame_buffer[24*MAX_NUM_FRAMES]; // [FRAME_BUFFER_SIZE]; //size of EEPROM -> to read faster??

  Rainbowduino(byte set_num_frames = 1);
  void reset();
  void set_num_frames(byte new_num_frames);
  void set_frame(byte frame_nr, byte* data);
  void set_frame_nr(byte frame_nr);
  void set_frame_row(byte frame_nr, byte row, byte data);
  void set_current_frame_row(byte row, byte data);
 
  //to set all 3 colors of each line
  void set_frame_line(byte frame_nr, byte x, byte red, byte green, byte blue);
  void set_current_frame_line(byte x, byte red, byte green, byte blue);

  //to set all 3 colors of each pixel
  void set_frame_pixel(byte frame_nr, byte x, byte y, byte red, byte green, byte blue);
  void set_current_frame_pixel(byte x, byte y, byte red, byte green, byte blue);

  void next_frame();
  void draw(byte level = 12);

private:
  byte current_frame_nr;
  word current_frame_offset;
  word off;  //buffer offset
  volatile byte current_row;
  volatile byte current_level;

  void draw_row(byte row, byte level, byte r, byte b, byte g);
  void draw_color(byte c);
  void enable_row(byte row);
};

#endif //RAINBOWDUINO.h

