import processing.serial.*;
PFont fontA;

Serial port;

int numX = 5;
int numY = 5;
int border = 10;
int rad    = 90;

int offY = rad - border;  
int offX = rad - border;

int speed = 15;

boolean serial = true;

Matrix matrix;

int current_frame = 0;
int current_delay = speed;
boolean record    = true;

void setup() {
  size(offX + numX * rad, offY + numY * rad);
  matrix = new Matrix( numX, numY );
  
  smooth();
  noStroke();
  fontA = loadFont("Courier-Bold-32.vlw");
  textFont(fontA, 20);
  
  try { 
    port = new Serial(this, Serial.list()[0], 115200);  
  }
  catch( Exception e) {
    port = null;
  }    
 
}

void draw() 
{
  if( record)  drawBack();
  else my_delay();

  for(int y=0; y< matrix.numY; y++) {    
    if(record) drawMatrix(y);
    // if(serial) drawSerial(y);
  }
}

void drawBack() {
  background(51);
  fill(255); 
  text( "Frame: "+ matrix.current_frame_nr + " Speed: " + speed, 20, numY * rad + offY*0.9);      
}

void my_delay() {
  current_delay--;
  if( current_delay == 0 || current_delay > speed) {
    matrix.nextFrame();
    current_delay = speed;      
  }  
}

void drawMatrix(int y) {
  for(int x=0; x<matrix.numX; x++) {
    int colors = matrix.current_pixel(x,y) ? 255 : 127;
    fill( colors, 153);
    ellipse( x*rad + offX, y*rad + offY, rad-border, rad-border);
  }
}

void drawSerial(int y) {  
  byte valX = matrix.row(y);
   //println("Serial: " + valX);
  if( port == null) return;
  port.write( valX );
}

/* +++++++++++++++ modes +++++++++++++++ */
void record() {
  if(record) return;
  matrix.current_frame_nr = 0;
  record = true;
  println("RECORD");         
}

void play() {
  if(!record) return;
  matrix.current_frame_nr = 0;
  record =  false;
  current_delay = speed;
  println("PLAY");     
}


void write() {
  println("Start Writing");
  port.write(255);
  port.write(250);
  for(int f=0; f< matrix.numFrames(); f++) {
    for(int y=0; y<matrix.numY; y++) {
      byte valX = matrix.row(f,y);
      port.write(valX);
      println( valX );
    }
  } 
  port.write(255);
  port.write(255);
  println("Done");
}

void read() {  
  port.write(255);
  port.write(251);
  serial = false;
  println("Done");
}


/* +++++++++++++++ ACTIONS +++++++++++++++ */
void mousePressed() {  
  if( !record) return;
  int x = mouseX2();
  int y = mouseY2();
  if( x >= matrix.numX || y >= matrix.numY) return;
  matrix.invert_current_pixel(x,y);
  println("pressed " + x + "," + y + "on pos " + mouseX + "," + mouseY);
}

void keyPressed() {  
  if( record ) {
    if( keyCode == 10)  { play();  }         //ENTER  

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





