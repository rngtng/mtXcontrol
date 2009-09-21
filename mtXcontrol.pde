
PFont fontA;
PFont fontLetter;

Matrix matrix;
Arduino arduino;

int border = 10;

int offY = 60;
int offX = 60;

int current_delay = 0;
int current_speed = 15;

boolean record    = true;
boolean keyCtrl   = false;
boolean keyMac   = false;

/* +++++++++++++++++++++++++++++ */

void setup() {
  matrix = new Matrix(8, 8);
  arduino = new Arduino(this); 
  /* setup_editor */
  size(offX + matrix.width(), offY + matrix.height() );
  smooth();
  noStroke();
  fontA = loadFont("Courier-Bold-32.vlw");
  fontLetter = loadFont("ArialMT-10.vlw");  
}

void draw()
{
  background(51);
  image(matrix.current_image(), offX/2, offY/2);

  fill(255); //white
  String txt_mode = (record) ? "Record" : "Play";
  String ard = (arduino.standalone) ? "Free" : "Ctrl";
  textFont(fontA, 20);
  text( "Frame: "+ matrix.current_frame_nr + " Speed: " + current_speed + " Mode: " + txt_mode + " Ard: " + ard, 20, matrix.height() + offY*0.9 );
  next_frame();
}

/* +++++++++++++++++++++++++++++ */

void next_frame() {
  if(record) return;
  if(current_delay < 1) {
    current_delay = current_speed;
    arduino.write_frame(matrix.next_frame());
  }
  current_delay--;
}

/* +++++++++++++++ ACTIONS +++++++++++++++ */
void mouseDragged() {
  if(!record) return;
  arduino.write_frame( matrix.drag(mouseX - offX/2, mouseY- offY/2) );
}

void mousePressed() {
  if(!record) return;
  arduino.write_frame( matrix.click(mouseX - offX/2, mouseY- offY/2) );
}

void keyPressed() {
  if( keyCode == 157 ) keyMac = true; //control
  if( keyCode == 17 )  keyCtrl = true; //control

  if( keyMac ) {
    if( keyCode == 10 ) arduino.toggle(matrix.current_frame()); // ENTER
    if( keyCode == 37) arduino.speed_up();   //arrow left
    if( keyCode == 39) arduino.speed_down(); //arrow right
    if( key == 'l') matrix = arduino.read_matrix(); //r        
    if( key == 's') arduino.write_matrix(matrix);    //w
  }
  else if( keyCtrl ) {
    if( keyCode > 48 &&  keyCode < 150) matrix.current_frame().set_letter(char(keyCode), fontLetter);
    if( keyCode == 37) matrix.current_frame().shift_left(); // arrow left
    if( keyCode == 39) matrix.current_frame().shift_right();   // arrow right      
    if( keyCode == 38) matrix.current_frame().shift_up(); // arrow left
    if( keyCode == 40) matrix.current_frame().shift_down();   // arrow right      
    if( keyCode == 8)  matrix.current_frame().clear();     //Del
    if( keyCode == 32) matrix.current_frame().fill_frame();      //Space
  }
  else {
    if( key == 'l') matrix = matrix.load_from_file(); //L
    if( key == 's') matrix.save_to_file();           //S

    if( record ) {
      if( keyCode == 10) play();      //ENTER
      if( keyCode == 37) matrix.previous_frame(); // arrow left
      if( keyCode == 39) matrix.next_frame();     // arrow right      

      if( key == ' ') matrix.add_frame();       //SPACE
      if( key == 'c') matrix.copy_last_frame();  //C
      if( key == 'd') matrix.delete_frame();    //D
    }
    else {
      if( keyCode == 10) record();       //ENTER
      if( keyCode == 37) speed_up();     //arrow left
      if( keyCode == 39) speed_down();   //arrow right    
    }
    arduino.write_frame(matrix.current_frame()); 
  }
  println("pressed " + key + " " + keyCode);
}

void keyReleased() {
  if( keyCode == 157 ) keyMac = false;
  if( keyCode == 17 )  keyCtrl = false;
}


/* +++++++++++++++ modes +++++++++++++++ */

void record() {
  matrix.current_frame_nr = 0;
  record = true;
  println("RECORD");
}

void play() {
  matrix.current_frame_nr = 0;
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
