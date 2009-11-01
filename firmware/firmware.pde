/*
 * Firmware.h version 1.02 - to run mtXcontrol Rainbowduino/Arduino
 * Copyright (c) 2009 Tobias Bielohlawek -> http://www.rngtng.com/mtxcontrol
 *
 */

#include <EEPROM.h>

/* 
 * Rainbowduino.h && Rainbowduino.cpp are symbolically linked to make it compile right from the beginning.
 * It's way more clean if you move "rainbowduino" Folder (including Rainbowduino.h && Rainbowduino.cpp) to you Arduino library 
 * and remove those links
 */
#include "Rainbowduino.h"

#define LIVE 0
#define STANDALONE 1

#define BAUD_RATE 9600

#define CRTL 255
#define RESET 255

#define WRITE_FRAME 253
#define WRITE_EEPROM 252
#define READ_EEPROM 251

#define SPEED 249
#define SPEED_INC 128 //B1000 0000
#define SPEED_DEC 1   //B0000 0001

#define DEFAULT_SPEED 5000

Rainbowduino rainbow = Rainbowduino(10);  //max 10 Frames

//running mode
byte mode = STANDALONE;

word current_delay = 0;
word current_speed = DEFAULT_SPEED;

void setup_timer()               
{
  TCCR2A |= (1 << WGM21) | (1 << WGM20);   
  TCCR2B |= (1<<CS22); // by clk/64
  TCCR2B &= ~((1<<CS21) | (1<<CS20));   // by clk/64
  TCCR2B &= ~((1<<WGM21) | (1<<WGM20));   // Use normal mode
  ASSR |= (0<<AS2);       // Use internal clock - external clock not used in Arduino
  TIMSK2 |= (1<<TOIE2) | (0<<OCIE2B);   //Timer2 Overflow Interrupt Enable
  TCNT2 = 0xE7; //gamma value
  sei();   
}

//Timer2 overflow interrupt vector handler
ISR(TIMER2_OVF_vect) {
  TCNT2 = 0xE7; //gamma value
  rainbow.draw();
}

void setup() {
  Serial.begin(BAUD_RATE);
  load_from_eeprom(0);
  reset();
  setup_timer();
}

void reset() {
  rainbow.reset();
  current_delay = 0;
  current_speed = DEFAULT_SPEED;
  mode = STANDALONE;
}

void loop() {
  check_serial();
  next_frame();
}

void next_frame() {
  if( mode == LIVE ) return;
  if(current_delay < 1) {
    current_delay = current_speed;
    rainbow.next_frame();
  }
  current_delay--;
}

void check_serial() {
  if( !Serial.available() ) return;
  byte value = read_serial();
  if( value == CRTL ) {
    switch( wait_and_read_serial() ) {
    case RESET:
      load_from_eeprom(0);
      reset();
      break;
    case WRITE_EEPROM: // TODO: add handshake sequence here???
      write_to_eeprom(0);
      break;
    case READ_EEPROM:
      send_eeprom(0);
      break;
    case WRITE_FRAME:
      write_to_current_frame();
      mode = LIVE;
      break;
    case SPEED:
      value = wait_and_read_serial();
      if( value == SPEED_INC && current_speed > 100 ) current_speed -= 100;
      if( value == SPEED_DEC ) current_speed += 100;
      break;
    }
  }
}

byte read_serial() {
  return Serial.read();
}

byte wait_and_read_serial() {
  while( !Serial.available() );
  return read_serial();
}

void write_to_current_frame() {
  for(byte row = 0; row < rainbow.num_rows; row++) {
    rainbow.set_current_frame_row(row, wait_and_read_serial());
  }
}

void write_to_eeprom( word addr ) {
  word num_frames = wait_and_read_serial();
  EEPROM.write(addr++, num_frames);

  for( word frame_nr = 0; frame_nr < num_frames; frame_nr++ ) {
    for( byte row = 0; row < rainbow.num_rows; row++ ) {
      EEPROM.write(addr++, wait_and_read_serial()); //TODO: this will likely fail if addr is bigger than we actually can adress
    }
  }
}

void send_eeprom( word addr ) {
  word num_frames = EEPROM.read(addr++); 
  num_frames = min(rainbow.max_num_frames, num_frames);
  Serial.write(num_frames);

  for( word frame_nr = 0; frame_nr < num_frames; frame_nr++ ) {
    for( byte row = 0; row < rainbow.num_rows; row++ ) {
      Serial.write( EEPROM.read(addr++) );
    }
    delay(1);
  }
}

void load_from_eeprom( word addr ) {
  rainbow.set_num_frames(EEPROM.read(addr++));
  for( word frame_nr = 0; frame_nr < rainbow.num_frames; frame_nr++ ) {
    for( byte row = 0; row < rainbow.num_rows; row++ ) {
      rainbow.set_frame_row(frame_nr, row, EEPROM.read(addr++));
    }
  }
}
