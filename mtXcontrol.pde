import processing.serial.*;
import cc.arduino.*;
PFont fontA;

Serial port;
Arduino arduino;

int numX = 4;
int numY = 4;
int border = 10;
int rad    = 90;

int offY = rad - border;  
int offX = rad - border;

int pinX = 2;
int pinY = 8;

int speed = 15;

boolean serial = true;

ArrayList frames  = new ArrayList();
int current_frame = 0;
int current_delay = speed;
boolean record    = true;

void setup() {
  size(offX + numX * rad, offY + numY * rad);
  smooth();
  noStroke();
  fontA = loadFont("Courier-Bold-32.vlw");
  textFont(fontA, 20);
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

  try { 
    port = new Serial(this, Serial.list()[0], 115200);  
    port.write(255);
    port.write(255);    
    // port.write(254);
    // port.write(numY);
  }
  catch( Exception e) {
    port = null;
  }    

  addFrame();  
}

void draw() 
{
  if( record)  drawBack();
  else my_delay();

  for(int y=0; y< numY; y++) {    
    if( record) drawMatrix(y);
    if( serial ) drawSerial(y);
  }
}

void drawBack() {
  background(51);
  fill(255); 
  text( "Frame: "+ current_frame + " Speed: " + speed, 20, numY * rad + offY*0.9);      
}

void my_delay() {
  current_delay--;
  if( current_delay == 0 || current_delay > speed) {
    current_frame = (current_frame >= frames.size() - 1) ? 0 : current_frame + 1;
    current_delay = speed;      
  }  
}

void drawMatrix(int y) {
  for(int x=0; x<numX; x++) {
    int colors = matrix(x,y) ? 255 : 127;
    fill( colors, 153);
    ellipse( x*rad + offX, y*rad + offY, rad-border, rad-border);
  }
}

void drawSerial(int y) {  
  int valX = matrix()[y];
   //println("Serial: " + valX);
  if( port == null) return;
  port.write( valX );
}

/* +++++++++++++++ modes +++++++++++++++ */
void record() {
  if(record) return;
  current_frame = 0;
  record = true;
  println("RECORD");         
}

void play() {
  if(!record) return;
  current_frame = 0;
  record =  false;
  current_delay = speed;
  println("PLAY");     
}

/* +++++++++++++++ DATA STRUCTURE +++++++++++++++ */
int[] matrix() {
  return matrix(current_frame);
}

int[] matrix(int f) {
  try {
    return (int[]) frames.get(f);
  }
  catch(Exception e ) {
    return (int[]) frames.get(0);
  }
}

boolean matrix(int x, int y) {
  return matrix(current_frame, x, y);
}

boolean matrix(int f, int x, int y) {
  return (matrix(f)[y] & (1 << x)) > 0;
}

/* +++++++++++++++ FILE +++++++++++++++ */
void writeMatrix() {
  println("Start Writing");
  port.write(255);
  port.write(253);
  for(int f=0; f< frames.size(); f++) {
    for(int y=0; y<numY; y++) {
      port.write(matrix(f)[y]);
      println( matrix(f)[y] );
    }
  } 
  port.write(255);
  port.write(255);
  println("Done");
}

void readMatrix() {  
  port.write(255);
  port.write(254);
  serial = false;
  println("Done");
}

void saveMatrix() {
  String savePath = selectOutput();  // Opens file chooser
  if (savePath == null) {
    println("No output file was selected...");
    return;
  } 
  PrintWriter output = createWriter(savePath);
  output.println(numX+","+numY+","+speed);

  for(int f=0; f< frames.size(); f++) {
    for(int y=0; y<numY; y++) {
      output.print(matrix(f)[y] + ",");
    }
    output.println();
  } 

  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file  
  println("SAVED to " + savePath);     
}

void loadMatrix() {
  String loadPath = selectInput("Choose a Matrix File to load");  // Opens file chooser
  if (loadPath == null) {
    println("No file was selected...");
    return;
  } 

  BufferedReader reader = createReader(loadPath);  
  String line = "";
  current_frame = 0;
  while( line != null ) {
    try {
      line = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    } 
  }  
}

/* +++++++++++++++ FRAME +++++++++++++++ */
void copyLastFrame() {
  if(current_frame == 0) return;
  for(int y=0; y< numY; y++) {
    matrix()[y] = matrix(current_frame-1)[y]; 
  }
}

void clearFrame() {
  setFrame(current_frame, 0);
}

void addFrame() {
  if( !frames.isEmpty()) current_frame++;
  frames.add( current_frame, new int[numY]); //init first frame
}

void fillFrame() {
  setFrame(current_frame, (1 << numX ) - 1);
}

void deleteFrame() {
  if( current_frame == 0) return;
  frames.remove(current_frame);
  current_frame--;  
}

void setFrame(int f, int value ) {
  for(int y=0; y< numY; y++) {
    matrix(f)[y] = value; 
  }  
}

/* +++++++++++++++ ACTIONS +++++++++++++++ */
void mousePressed() {  
  if( !record) return;
  int x = mouseX2();
  int y = mouseY2();
  if( x >= numX || y >= numY) return;
  matrix()[y] = matrix()[y] ^ (1 << x) ;
  println("pressed " + x + "," + y + "on pos " + mouseX + "," + mouseY);
}

void keyPressed() {  
  if( record ) {
    if( keyCode == 10)  { port.write(255); port.write(255); play();  }         //ENTER  

    if( keyCode == 39) current_frame = (current_frame + 1 ) % frames.size();  // arrow right
    if( keyCode == 37) current_frame = ( current_frame == 0 ) ?  frames.size() - 1 : current_frame - 1; //B OR arrow left

    if( keyCode == 32) addFrame();       //SPACE
    if( keyCode == 67) copyLastFrame();  //C
    if( keyCode == 68) deleteFrame();    //D
    if( keyCode == 70) fillFrame();      //F
    if( keyCode == 88) clearFrame();     //X        

    //SAVE +  LOAD    
    if( keyCode == 87) writeMatrix();     //W
    if( keyCode == 76) loadMatrix();     //L 
    if( keyCode == 83) saveMatrix();     //S
  }
  else {
    if( keyCode == 37 && speed > 1) speed -=1; //arrow left
    if( keyCode == 39 && speed < 100) speed +=1;  //arrow right
    if( keyCode == 10) record();           //ENTER
  }  
  if( keyCode == 82 ) readMatrix(); // T
  if( keyCode == 84 ) serial = !serial; // T
  drawBack();  
  println("pressed " + keyCode);   
}

int mouseY2() {
  return o(mouseY- offY/2 ); 
}

int mouseX2() {
  return o(mouseX - offX/2 ); 
}

int o(int value) {
  return value / rad;
}





