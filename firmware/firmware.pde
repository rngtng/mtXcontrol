/*
 * mtXControl Arduino Firmware
 */

#include <EEPROM.h>
#include "rainbow.h"

#define LIVE 0 
#define STANDALONE 1 

#define FRAME_BUFFER_SIZE 256 //BYTES

#define BAUD_RATE 14400

#define CRTL 255
#define RESET 255

#define WRITE_FRAME 253
#define WRITE_EEPROM 252
#define READ_EEPROM 251

#define SPEED 249
#define SPEED_INC 128 //B1000 0000
#define SPEED_DEC 1   //B0000 0001

#define DEFAULT_SPEED 5000

// word is same as unsigend int

// int numX = 8;
byte numY = 24;
byte numFrames = 0;

word current_frame_nr = 0;
word current_frame_offset = 0;
byte current_row = 0;

//running mode
byte mode = STANDALONE;

word current_delay = 0;
word current_speed = DEFAULT_SPEED; 

byte frame_buffer[FRAME_BUFFER_SIZE]; //size of EEPROM -> to read faster??

void setup_timer2() {
  TCCR2A = 0;
  TCCR2B = 1<<CS22 | 0 <<CS21 | 0<<CS20; 

  //Timer2 Overflow Interrupt Enable   
  TIMSK2 = 1<<TOIE2;
  TCNT2 = 0 ; 
  sei();   
}


void setup_timer2_o() {
  //  TCCR2A |= (1 << WGM21) | (1 << WGM20);   
  TCCR2A = 0;
  TCCR2B |= (1<<CS22);   // by clk/64
  TCCR2B &= ~((1<<CS21) | (1<<CS20));   // by clk/64
  TCCR2B &= ~((1<<WGM21) | (1<<WGM20));   // Use normal mode
  ASSR |= (0<<AS2);       // Use internal clock - external clock not used in Arduino
  TIMSK2 |= (1<<TOIE2) | (0<<OCIE2B);   //Timer2 Overflow Interrupt Enable
  //  TCNT2 = GamaTab[0];
  sei();   
}

//Timer2 overflow interrupt vector handler
ISR(TIMER2_OVF_vect) {
  set_row( current_row / 3, 14, frame_buffer[current_frame_offset + current_row], frame_buffer[current_frame_offset + current_row+1], frame_buffer[current_frame_offset + current_row+2]);    
  current_row = (current_row >= numY - 1) ? 0 : current_row + 3; 
}

void setup() {
  Serial.begin(BAUD_RATE);  

  // init ports  
  //DDRD = DDRD | B11111100;
  // PORTD = PIND & B00000011;

  DDRD=0xff;
  DDRC=0xff;
  DDRB=0xff;
  PORTB=0;
  PORTD=0;  

  /* 
   PORTD = PIND & B00000011;
   DDRB = DDRB | B00111111;
   PORTB = PINB &  B11000000;  
   */

//  load_from_eeprom(0);
  load_single(0);
  reset();
  setup_timer2();

}

void reset() {
  current_frame_nr = 0;   
  current_row = 0;
  current_frame_offset = current_frame_nr * numY;
  current_delay = 0;
  current_speed = DEFAULT_SPEED;
  mode = STANDALONE;
}

void loop() {
  check_serial();
  next_frame();
  //set_row(1, 1, B10010000, B01000100, B0011001);
  //delay(10); 
}

void next_frame_ol() {
  for( int i = 0; i < 8; i++ ) {          
    for( int j = 0; j < 5; j++ ) {    
      set_row(abs(i-2), 1, B00000000, B00000000, B11111111);
      set_row(abs(i-1), (i+1) << 2, B00000000, B11111111, B00000000);
      set_row(i, (i+1) << 4, B11111111, B00000000, B00000000);
    }
  }
  delay(10);
}

void next_frame() {
  if( mode == LIVE ) return; 
  if(current_delay < 1) {      
    current_delay = current_speed; // / numY /numY * 300;   
    current_frame_nr++;
    if(current_frame_nr >= numFrames) current_frame_nr = 0;
    current_frame_offset = current_frame_nr * numY;
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
    case WRITE_EEPROM: 
      write_to_eeprom(0);
      break;
    case READ_EEPROM: 
      send_eeprom(0);
      break;      
    case WRITE_FRAME:   
      write_to_frame( current_frame_nr );
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

void write_to_frame(word frame_nr ) {  
  byte value;
  word frame_offset = frame_nr * numY;
  for( byte row = 0; row < numY; row++ ) {
    value = wait_and_read_serial();
    frame_buffer[frame_offset + row] = value;  
  }
}

void write_to_eeprom( word addr ) {
  //int slot = wait_and_read_serial();
  // byte serialY = wait_and_read_serial(); // numY
  // byte serialSpeed = wait_and_read_serial(); // numY
  byte new_numFrames = wait_and_read_serial();
  EEPROM.write(addr, new_numFrames);  

  byte new_numY = wait_and_read_serial();
  EEPROM.write(addr + 1, new_numY);  

  word max_row = new_numFrames * new_numY;
  if(max_row > FRAME_BUFFER_SIZE)  max_row = FRAME_BUFFER_SIZE;
  byte value;
  for( unsigned  int row = 0; row < max_row; row++ ) {
    value = wait_and_read_serial();
    EEPROM.write(addr + 2 + row, value);      
  }
}

void load_single( word addr ) {
  numFrames = 1;

  word max_row = numFrames * numY;
  if(max_row > FRAME_BUFFER_SIZE)  max_row = FRAME_BUFFER_SIZE;
  for( word row = 0; row < max_row; row++ ) {
    frame_buffer[row] = 1 << (row / 3);
  }
}

void load_from_eeprom( word addr ) {
  numFrames = EEPROM.read(addr);
  numY      = EEPROM.read(addr + 1); 

  word max_row = numFrames * numY;
  if(max_row > FRAME_BUFFER_SIZE)  max_row = FRAME_BUFFER_SIZE;
  for( word row = 0; row < max_row; row++ ) {
    frame_buffer[row] = EEPROM.read(addr + 2 + row);
  }
}

void send_eeprom( word addr ) {
  byte new_numFrames = EEPROM.read(addr);
  Serial.write(new_numFrames);
  byte new_numY      = EEPROM.read(addr + 1); 
  Serial.write(new_numY);

  word max_row = new_numFrames * new_numY;
  for( word row = 0; row < max_row; row++ ) {
    Serial.write( EEPROM.read(addr + 2 + row) );
  }
}

void set_row(byte line, byte level, byte r, byte b, byte g ) {
  open_line(line);
  for( byte i = 0; i < 16; i++ ) {    
    disable_oe;
    le_high;  
    set_color( (i < level) ? b : 0 );
    set_color( (i < level) ? r : 0 );
    set_color( (i < level) ? g : 0 );
    le_low;   
    enable_oe;
  }   
}


void set_color(byte c ) {
  for(byte color=0;color<8;color++) {   
    if( c > 127 )  { 
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
void open_line(byte line)     // open the scaning line 
{
  if(line < 3) {
    PORTB  = (PINB & ~0x07) | 0x04 >> line;
    PORTD  = (PIND & ~0xF8); 
  }
  else {
    PORTB  = (PINB & ~0x07);
    PORTD  = (PIND & ~0xF8) | 0x80 >> (line - 3); 
  }
}

/* void setRow(byte row, byte value) {
 PORTB =  255 - value; // << 2 ) 
 PORTD = (1 << (7-row) ) | (PIND & B00000011);
 } */
