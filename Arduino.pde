import cc.arduino.*;

Arduino arduino;
int pinX = 2;
int pinY = 8;


try {
  arduino = new Arduino(this, Arduino.list()[0]); // v2
  for(int y=0; y<numY; y++) {
    arduino.pinMode( pinY + y, Arduino.OUTPUT);
    arduino.digitalWrite( pinY + y, Arduino.HIGH);
  }  
  for(int x=0; x<numX; x++) {
    arduino.pinMode( pinX + x, Arduino.OUTPUT);    
    arduino.digitalWrite( pinX + x, Arduino.LOW);
  }
}
catch( Exception e) {
  arduino = null;
}  


