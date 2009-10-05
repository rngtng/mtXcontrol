/*
Rainbowduino.h v.01 - A driver to run Seeedstudio 8x8 RBG LED Matrix
Copyright (c) 2009 Tobias Bielohlawek  All right reserved.
*/

// include this library's description file
#include "Rainbowduino.h"

// include core Wiring API
#include "WProgram.h"

// include description files for other libraries used (if any)
#include "pins_arduino.h"
#include "WConstants.h"

// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances
Rainbowduino::Rainbowduino(byte set_num_frames) {
  DDRD = 0xff;
  DDRC = 0xff;
  DDRB = 0xff;
  PORTB = 0;
  PORTD = 0;
  num_frames = set_num_frames;
  num_rows = NUM_ROWS;
  reset();
}


//==============================================================
void Rainbowduino::reset() {
  current_frame_nr = 0;
  current_row = 0;
  current_frame_offset = 0;
}

void Rainbowduino::set_frame(byte frame_nr, byte* data)
{
  if( frame_nr > num_frames) return;
  word offset = frame_nr * num_rows;
  for( byte row = 0; row < num_rows; row++ ) {
    frame_buffer[offset+row] = data[row];
  }
}

void Rainbowduino::set_frame_nr(byte frame_nr)
{
  if(frame_nr < num_frames) current_frame_nr = frame_nr;
}

void Rainbowduino::set_current_frame_row(byte row, byte data)
{
  set_frame_row(current_frame_nr, row, data);
}

void Rainbowduino::set_frame_row(byte frame_nr, byte row, byte data)
{
  if( frame_nr > num_frames) return;
  word offset = frame_nr * num_rows;
  frame_buffer[offset+row] = data;
}

void Rainbowduino::next_frame()
{
  current_frame_nr++;
  if(current_frame_nr >= num_frames) current_frame_nr = 0;
}

//==============================================================
void Rainbowduino::draw() {
  off = current_frame_nr * num_rows + current_row;
  draw_row(current_row / 3, 31, frame_buffer[off++], frame_buffer[off++], frame_buffer[off++]);
  current_row = (current_row >= num_rows - 1) ? 0 : current_row+3;  
}

//==============================================================
void Rainbowduino::draw_row(byte row, byte level, byte r, byte b, byte g) {
  enable_row(row);
  for(byte i = 0; i < 32; i++) {
    disable_oe;
    le_high;
    draw_color( (i < level) ? b : 0 );
    draw_color( (i < level) ? r : 0 );
    draw_color( (i < level) ? g : 0 );
    le_low;
    enable_oe;
  }
}

//==============================================================
void Rainbowduino::draw_color(byte c) {
  for(byte color = 0; color < 8; color++) {
    if(c > 127) {
      shift_data_1;
    }
    else {
      shift_data_0;
    }
    c = c << 1;
    clk_rising;
  }
}

//==============================================================
void Rainbowduino::enable_row(byte row) {   // open the scaning row
  //better? shift word value, take upper and lower part!?  
  if(row < 3) {
    PORTB  = (PINB & ~0x07) | 0x04 >> row;
    PORTD  = (PIND & ~0xF8);
  }
  else {
    PORTB  = (PINB & ~0x07);
    PORTD  = (PIND & ~0xF8) | 0x80 >> (row - 3);
  }
}