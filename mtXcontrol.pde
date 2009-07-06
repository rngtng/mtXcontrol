
PFont fontA;

Matrix matrix;
Arduino arduino;

Pixel last_color = null;
Frame current_frame = null;

int border = 10;
int rad    = 70;

int offY = rad - border;
int offX = rad - border;

int last_y = 0;
int last_x = 0;

int cols = 8;
int rows = 8;

int current_delay = 0;
int current_speed = 15;

boolean record    = true;
boolean keyCtrl   = false;

/* +++++++++++++++++++++++++++++ */

void setup() {
  setup_editor();
  matrix = new Matrix( cols, rows );
  current_frame = matrix.add_frame();
  arduino = new Arduino(this);
}

void setup_editor() {
  size(offX + cols * rad, offY + rows * rad);
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
  String txt_mode = (record) ? "Record" : "Play";
  String ard = (arduino.standalone) ? "Free" : "Ctrl";
  
  text( "Frame: "+ matrix.current_frame_nr + " Speed: " + current_speed + " Mode: " + txt_mode + " Ard: " + ard, 20, rows * rad + offY*0.9 );
}

void draw_matrix() {
  Pixel pixel; 
  for(int y=0; y<current_frame.rows; y++) {
    for(int x=0; x<current_frame.cols; x++) {      
      pixel = current_frame.get_pixel(x,y);
      fill( -254 * pixel.r, -254 * pixel.g, -254 * pixel.b);      
      ellipse( x*rad + offX, y*rad + offY, rad-border, rad-border);
    }
  }
}

/* +++++++++++++++++++++++++++++ */

void next_frame() {
  if(record) return;
  if( current_delay < 1) {
    current_delay = current_speed;
    current_frame = matrix.next_frame();
    arduino.write_frame(current_frame);
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

  if( keyCtrl ) {
    if( keyCode == 10 ) arduino.toggle(current_frame); // ENTER
    if( keyCode == 37) arduino.speed_up();   //arrow left
    if( keyCode == 39) arduino.speed_down(); //arrow right
    if( key == 'l') { matrix = arduino.read_matrix();  current_frame = matrix.current_frame(); } //r        
    if( key == 's') arduino.write_matrix(matrix);    //w
  }
  else {
    if( key == 'l') { matrix = matrix.load_from_file();  current_frame = matrix.current_frame(); }  //L
    if( key == 's') matrix.save_to_file();           //S

    if( record ) {
      if( keyCode == 10) play();      //ENTER
      if( keyCode == 37) current_frame = matrix.previous_frame(); // arrow left
      if( keyCode == 39) current_frame = matrix.next_frame();     // arrow right      

      if( key == ' ') current_frame = matrix.add_frame();       //SPACE
      if( key == 'c') current_frame = matrix.copy_last_frame();  //C
      if( key == 'd') current_frame = matrix.delete_frame();    //D
      if( key == 'f') current_frame.fill();      //F
      if( key == 'x') current_frame.clear();     //X
    }
    else {
      if( keyCode == 10) record();       //ENTER
      if( keyCode == 37) speed_up();     //arrow left
      if( keyCode == 39) speed_down();   //arrow right    
    }
    arduino.write_frame(current_frame); 
  }
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
  last_color = current_frame.set_pixel(x, y, last_color);
  last_x = x;
  last_y = y;  
  arduino.write_frame(current_frame);
}

void record() {
  matrix.current_frame_nr = 0;
  record = true;
  println("RECORD");
}

void play() {
  current_frame = matrix.first_frame();
  record =  false;
  println("PLAY");
}

void speed_up() {
  if( current_speed < 2 ) return;
  current_speed--;
}

void speed_down() {
  current_speed++;
}

