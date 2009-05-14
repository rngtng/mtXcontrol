/*
 * LED Matrix
 *
 */

#include <EEPROM.h>

int addr = 0;

int val1 = 0;
int val2 = 0;

int speed2 = 0; 

int mode = 0;   //0  = LIVE, 1 = READ, 2 = WRITE

int x = 0;
int y = 0;
int maxY = 4;

void setup()
{
  Serial.begin(115200);
  //maxY = EEPROM.read(0); //first BYTE is max Y

  for(int i = 2; i < 13; i++ ) {
    pinMode(i, OUTPUT);      // sets the digital pin as output
    digitalWrite(i, LOW);
  }      
}


void loop()
{
  if(Serial.available()) {
    read_serial();    
    if( val2 == 255 ) 
    {       
      if( val1 == 255 ) mode = 0; // LIVE 
      if( val1 == 254 ) { mode = 1;  addr= 0; y= 0; }  //READ
      if( val1 == 253 ) { mode = 2;  addr= 0; y= 0; } //WRITE

      if( val1 == 250 ) speed2++; 
      if( val1 == 251 && speed2 > 1 ) speed2--; 
    }
    //else if( val2 == 254 ) {
      //maxY = val1;
    //}
    else {
      if( mode == 2 ) writeE();
      if( mode == 0 ) blink(val1);
    } 
  }

  if( mode == 1 ) playE();
  //  delayMillisecond(speed2);
}

void read_serial() {
  val2 = val1;
  val1 = Serial.read();
}

void blink(int colX) {    
  PORTD = (colX << 2 )| (PIND & B00000011);
  PORTB = ~( 1 << y );
  y++;  
  if(y >= maxY) y = 0;
}

void writeE() {  
  if( addr > 512) return; 
  EEPROM.write(addr, val1);
  addr++;
}

void playE() {
  x = EEPROM.read(addr);  
  if(addr == 512 || x == 255 ) {
    addr = 0;
    x = EEPROM.read(addr);  
  }
  addr++;
  blink(x);
}
