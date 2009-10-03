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
Rainbowduino::Rainbowduino() {
  DDRD = 0xff;
  DDRC = 0xff;
  DDRB = 0xff;
  PORTB = 0;
  PORTD = 0;
}

//==============================================================
void Rainbowduino::set_row(byte line, byte level, byte r, byte b, byte g) {
  open_line(line);
  for(byte i = 0; i < 16; i++) {
    disable_oe;
    le_high;
    set_color( (i < level) ? b : 0 );
    set_color( (i < level) ? r : 0 );
    set_color( (i < level) ? g : 0 );
    le_low;
    enable_oe;
  }
}

//==============================================================
void Rainbowduino::set_color(byte c) {
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
void Rainbowduino::open_line(byte line) {   // open the scaning line
  if(line < 3) {
    PORTB  = (PINB & ~0x07) | 0x04 >> line;
    PORTD  = (PIND & ~0xF8);
  }
  else {
    PORTB  = (PINB & ~0x07);
    PORTD  = (PIND & ~0xF8) | 0x80 >> (line - 3);
  }
}

/* void Rainbowduino::setRow(byte row, byte value) {
PORTB =  255 - value; // << 2 )
PORTD = (1 << (7-row) ) | (PIND & B00000011);
} */