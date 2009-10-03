/*
RAINBOWDUINO.h - A driver to run Seeedstudio 8x8 RBG LED Matrix
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
//============================================
//#define open_line0	{PORTB=0x04;} //B00000100
//#define open_line1	{PORTB=0x02;} //B00000010
//#define open_line2	{PORTB=0x01;} //B00000001
//#define open_line3	{PORTD=0x80;} //B10000000
//#define open_line4	{PORTD=0x40;} //B01000000
//#define open_line5	{PORTD=0x20;} //B00100000
//#define open_line6	{PORTD=0x10;} //B00010000
//#define open_line7	{PORTD=0x08;} //B00001000

//#define close_all_line	{PORTD&=~0xf8;PORTB&=~0x07;}
//============================================

class Rainbowduino {

public:
  Rainbowduino();
  void set_row(byte line, byte level, byte r, byte b, byte g );
  void set_color(byte c );
  void open_line(byte line);
};

#endif	//RAINBOWDUINO.h



