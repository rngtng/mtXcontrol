/*
 * mtXControl Arduino Firmware
 */

#include <EEPROM.h>
#include <Rainbowduino.h>

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

byte rows = 24;
byte numFrames = 0;

Rainbowduino rainbow = Rainbowduino();

word current_frame_nr = 0;   // word is same as unsigend int
word current_frame_offset = 0;
byte current_row = 0;

//running mode
byte mode = STANDALONE;

word current_delay = 0;
word current_speed = DEFAULT_SPEED; 

byte frame_buffer[FRAME_BUFFER_SIZE]; //size of EEPROM -> to read faster??

void setup_timer() {
  TCCR2A = 0;
  TCCR2B = 1<<CS22 | 0 <<CS21 | 0<<CS20; 

  TIMSK2 = 1<<TOIE2;   //Timer2 Overflow Interrupt Enable   
  TCNT2 = 0;    //  TCNT2 = GamaTab[0];
  sei();   
}

//Timer2 overflow interrupt vector handler
ISR(TIMER2_OVF_vect) {
  rainbow.set_row( current_row / 3, 15, frame_buffer[current_frame_offset + current_row], frame_buffer[current_frame_offset + current_row+1], frame_buffer[current_frame_offset + current_row+2]);
  current_row = (current_row >= rows - 1) ? 0 : current_row + 3; 
}

void setup() {
  Serial.begin(BAUD_RATE);  

  load_from_eeprom(0);
  //load_single(0);
  reset();
  setup_timer();
}

void reset() {
  current_frame_nr = 0;   
  current_row = 0;
  current_frame_offset = current_frame_nr * rows;
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
    current_delay = current_speed; // / rows /rows * 300;   
    current_frame_nr++;
    if(current_frame_nr >= numFrames) current_frame_nr = 0;
    current_frame_offset = current_frame_nr * rows;
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
  word frame_offset = frame_nr * rows;
  for( byte row = 0; row < rows; row++ ) {
    value = wait_and_read_serial();
    frame_buffer[frame_offset + row] = value;  
  }
}

void write_to_eeprom( word addr ) {
  //int slot = wait_and_read_serial();
  // byte serialY = wait_and_read_serial(); // rows
  // byte serialSpeed = wait_and_read_serial(); // rows
  byte new_numFrames = wait_and_read_serial();
  EEPROM.write(addr, new_numFrames);  

  byte new_rows = wait_and_read_serial();
  EEPROM.write(addr + 1, new_rows);  

  word max_row = new_numFrames * new_rows;
  if(max_row > FRAME_BUFFER_SIZE)  max_row = FRAME_BUFFER_SIZE;
  byte value;
  for( unsigned  int row = 0; row < max_row; row++ ) {
    value = wait_and_read_serial();
    EEPROM.write(addr + 2 + row, value);      
  }
}

void send_eeprom( word addr ) {
  byte new_numFrames = EEPROM.read(addr);
  Serial.write(new_numFrames);
  byte new_rows      = EEPROM.read(addr + 1); 
  Serial.write(new_rows);

  word max_row = new_numFrames * new_rows;
  for( word row = 0; row < max_row; row++ ) {
    Serial.write( EEPROM.read(addr + 2 + row) );
  }
}

void load_single( word addr ) {
  numFrames = 1;

  word max_row = numFrames * rows;
  if(max_row > FRAME_BUFFER_SIZE)  max_row = FRAME_BUFFER_SIZE;
  for( word row = 0; row < max_row; row++ ) {
    frame_buffer[row] = 1 << (row / 3);
  }
}

void load_from_eeprom( word addr ) {
  numFrames = EEPROM.read(addr);
  rows      = EEPROM.read(addr + 1); 

  word max_row = numFrames * rows;
  if(max_row > FRAME_BUFFER_SIZE)  max_row = FRAME_BUFFER_SIZE;
  for( word row = 0; row < max_row; row++ ) {
    frame_buffer[row] = EEPROM.read(addr + 2 + row);
  }
}


