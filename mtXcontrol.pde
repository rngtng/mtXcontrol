
PFont fontA;
PFont fontLetter;

Matrix matrix;
Arduino arduino;

int border = 10;

int offY = 30;
int offX = 30;

int current_delay = 0;
int current_speed = 15;

boolean record    = true;
boolean keyCtrl   = false;
boolean keyMac   = false;

Button[] buttons;

/* +++++++++++++++++++++++++++++ */

void setup() {
  matrix = new Matrix(8, 8);
  arduino = new Arduino(this); 
  /* setup_editor */
  //size(2*offX + matrix.width(), 2*offY + matrix.height() );
  size(780,720 );
  smooth();
  noStroke();
  fontA = loadFont("Courier-Bold-32.vlw");
  fontLetter = loadFont("ArialMT-10.vlw");  
  setup_buttons();
}

void setup_buttons() {
  buttons = new Button[matrix.rows+matrix.cols+1]; 
  int button_size = 15;
  color button_color = #444444;
  color button_color_over = #999999;
  int offset = 10;

  for(int i = 0; i < matrix.rows; i++ ) {
    buttons[i] = new RectButton( offX + matrix.width() + offset, offY + i * matrix.rad + matrix.border / 2, button_size, matrix.rad - matrix.border, button_color, button_color_over );
  }  
  for(int i = 0; i < matrix.cols; i++ ) {
    buttons[matrix.rows + i] = new RectButton( offX + i * matrix.rad + matrix.border / 2, offY + matrix.width() + offset, matrix.rad - matrix.border, button_size, button_color, button_color_over );
  } 
  buttons[matrix.rows + matrix.cols] = new SquareButton( offX + matrix.width() + offset, offY + matrix.width() + offset, button_size, button_color, button_color_over );
}

void draw()
{
  background(51);
  image(matrix.current_frame_image(), offX, offY);
  for(int i = 0; i < matrix.rows+matrix.cols+1; i++ ) {
    buttons[i].display();
  }
  
  draw_frames(); 
  fill(255); //white
  /*  String txt_mode = (record) ? "Record" : "Play";
   String ard = (arduino.standalone) ? "Free" : "Ctrl";
   textFont(fontA, 20);
   text( "Frame: "+ matrix.current_frame_nr + " Speed: " + current_speed + " Mode: " + txt_mode + " Ard: " + ard, 20, matrix.height() + 2*offY*0.9 );
   */
  next_frame();

}

void draw_frames() {
  int i;
  int img_x;
  int img_y = offY + matrix.height() + 40;  
  int img_width = 59;
  for(int x = 0; x < 10; x++ ) {
    i = ( matrix.current_frame_nr > 9 ) ? (matrix.current_frame_nr - 9 + x) : x;
    img_x = offX + img_width * x ;
    noFill();
    stroke(#000000);
    rect(img_x + 5, img_y, img_width - 10, img_width - 10);
    if( i == matrix.current_frame_nr) {
     noFill();
     stroke(#FFFF00);
     rect(img_x + 5, img_y, img_width - 10, img_width - 10);      
    }
    if( i < 0 || i >= matrix.num_frames()) continue;
    image( matrix.frame(i).draw_thumb(6, 4), img_x + 6, img_y + 1);
    fill(255); //white
    noStroke();
    textFont(fontA, 15);
    text( i + 1, img_x + 25, img_y + 62); 
  }
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
  arduino.write_frame( matrix.drag(mouseX - offX, mouseY - offY) );
}

void mousePressed() {
  if(!record) return;
  arduino.write_frame( matrix.click(mouseX - offX, mouseY - offY) );
}

void mouseMoved() {
    for(int i = 0; i < matrix.rows+matrix.cols+1; i++ ) {
      buttons[i].update();
    }
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


