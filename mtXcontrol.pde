
PFont fontA;

Matrix matrix;
Arduino arduino;


int border = 10;
int rad    = 90;

int offY = rad - border;
int offX = rad - border;

int last_y = 0;
int last_x = 0;

int numX = 5;
int numY = 5;

int current_delay = 0;
int current_speed = 15;

boolean record    = true;
boolean keyCtrl   = false;

/* +++++++++++++++++++++++++++++ */

void setup() {
  setup_editor();
  matrix = new Matrix( numX, numY );
  matrix.add_frame();
  arduino = new Arduino(this);
}

void setup_editor() {
  size(offX + numX * rad, offY + numY * rad);
  smooth();
  noStroke();
  fontA = loadFont("Courier-Bold-32.vlw");
  textFont(fontA, 20);
}


void draw()
{
  draw_background();
  draw_matrix();
  next_frame();
}

/* +++++++++++++++++++++++++++++ */

void draw_background() {
  background(51);
  fill(255);
  String txt_mode = ((record) ? "Record" : "Play");
  text( "Frame: "+ matrix.current_frame_nr + " Speed: " + current_speed + " Mode: " + txt_mode, 20, numY * rad + offY*0.9 );
}

void draw_matrix() {
  for(int y=0; y<matrix.numY; y++) {
    for(int x=0; x<matrix.numX; x++) {
      int colors = matrix.current_pixel(x,y) ? 255 : 127;
      fill( colors, 153);
      ellipse( x*rad + offX, y*rad + offY, rad-border, rad-border);
    }
  }
}

/* +++++++++++++++++++++++++++++ */

void next_frame() {
  if(record) return;
  if( current_delay < 1) {
    current_delay = current_speed;
    matrix.next_frame();
    arduino.write_frame(matrix);
  }
  current_delay--;
}

/* +++++++++++++++ ACTIONS +++++++++++++++ */
void mouseDragged() {
  matrix_update(mouseX2(), mouseY2(), false );
}

void mousePressed() {
  matrix_update(mouseX2(), mouseY2(), true );
}

void keyPressed() {
  if( keyCode == 157 ) keyCtrl = true; //control

  if( record ) {
    if( !keyCtrl ) {
      if( keyCode == 10) play();      //ENTER
      if( keyCode == 37) matrix.previous_frame(); // arrow left
      if( keyCode == 39) matrix.next_frame();     // arrow right      
    }

    if( key == ' ') matrix.add_frame();       //SPACE
    if( key == 'c') matrix.copy_last_frame();  //C
    if( key == 'd') matrix.delete_frame();    //D
    if( key == 'f') matrix.fill_frame();      //F
    if( key == 'x') matrix.clear_frame();     //X

    //SAVE +  LOAD
    if( key == 'w') arduino.write_matrix(matrix);    //w
    if( key == 'r') matrix = arduino.read_matrix();  //r
    if( key == 'l') matrix = matrix.load_from_file();         //L
    if( key == 's') matrix.save_to_file();           //S
  }
  else {
    if( !keyCtrl ) {
      if( keyCode == 10) record();       //ENTER
      if( keyCode == 37) speed_up();     //arrow left
      if( keyCode == 39) speed_down();   //arrow right    
    }
  }

  if( keyCtrl ) {
    if( keyCode == 10 ) arduino.toggle(matrix); // ENTER
    if( keyCode == 37) arduino.speed_up();   //arrow left
    if( keyCode == 39) arduino.speed_down(); //arrow right
  }

  arduino.write_frame(matrix);
  // println("pressed " + key + " " + keyCode);
}

void keyReleased() {
  if( keyCode == 157 ) keyCtrl = false;
}

int mouseY2() {
  return (mouseY- offY/2 ) / rad;
}

int mouseX2() {
  return (mouseX - offX/2 ) / rad;
}


/* +++++++++++++++ modes +++++++++++++++ */


void matrix_update( int x, int y, boolean ignore_last) {  
  if( !record) return;
  if( !ignore_last && x == last_x && y == last_y) return;
  matrix.invert_current_pixel( x, y );
  last_x = x;
  last_y = y;  
  arduino.write_frame(matrix);
}

void record() {
  // if(record) return;
  matrix.current_frame_nr = 0;
  record = true;
  println("RECORD");
}

void play() {
  // if(!record) return;
  matrix.current_frame_nr = 0;
  record =  false;
  //  current_delay = current_speed;
  println("PLAY");
}

void speed_up() {
  if( current_speed < 2 ) return;
  current_speed--;
}

void speed_down() {
  //  if( current_speed < 2 ) return;
  current_speed++;
}

/* +++++++++++++++++++++++++++++ */





