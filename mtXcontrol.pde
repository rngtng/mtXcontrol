
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
boolean update = true;
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
  buttons = new Button[matrix.rows+matrix.cols+1+20]; 
  int button_size = 15;
  int offset = 10;
  int button_index = 0;
  
  buttons[button_index++] = new TextToggleButton( "Mode: RECORD", "Mode: PLAY", offX + matrix.width() + offset + 30, 30, 130, 25, #444444, #999999);
  buttons[button_index++] = new TextToggleButton( "Arduino: FREE", "Arduino: CTRL", offX + matrix.width() + offset + 30, 60, 130, 25, #444444, #999999);

  buttons[button_index++] = new ActionButton( "Load", offX + matrix.width() + offset + 30, 120, 130, 25, #444444, #999999);
  buttons[button_index++] = new ActionButton( "Save", offX + matrix.width() + offset + 30, 150, 130, 25, #444444, #999999);
 
  buttons[button_index++] = new ActionButton( "Add",    offX + matrix.width() + offset + 30, 220, 130, 25, #444444, #999999);
  buttons[button_index++] = new ActionButton( "Delete", offX + matrix.width() + offset + 30, 250, 130, 25, #444444, #999999);
  
  buttons[button_index++] = new ActionButton( "L",    offX + matrix.width() + offset + 30, 310, 40, 25, #444444, #999999);
  buttons[button_index++] = new ActionButton( "R",    offX + matrix.width() + offset + 120, 310, 40, 25, #444444, #999999);
  buttons[button_index++] = new ActionButton( "U",    offX + matrix.width() + offset + 75, 290, 40, 25, #444444, #999999);
  buttons[button_index++] = new ActionButton( "D",    offX + matrix.width() + offset + 75, 325, 40, 25, #444444, #999999);
  
  
  buttons[button_index++] = new ActionButton( "Copy",    offX + matrix.width() + offset + 30, 365, 130, 25, #444444, #999999);
  buttons[button_index++] = new ActionButton( "Fill",    offX + matrix.width() + offset + 30, 395, 130, 25, #444444, #999999);
  buttons[button_index++] = new ActionButton( "Clear", offX + matrix.width() + offset + 30, 425, 130, 25, #444444, #999999);
 
  
//  buttons[button_index++] = new RectButton( offX + matrix.width() + offset + 40, 570, 100, 20, new Pixel().get_color());
//  buttons[button_index++] = new TextButton( "Save", offX + matrix.width() + offset + 30, 270, 80, 20, #444444, #999999);
  
  color button_color = #333333;
  color button_color_over = #999999;
  for(int i = 0; i < matrix.rows; i++ ) {
      buttons[button_index++] = new RectButton( offX + matrix.width() + offset, offY + i * matrix.rad + matrix.border / 2, button_size, matrix.rad - matrix.border, button_color, button_color_over );
  }  
  for(int i = 0; i < matrix.cols; i++ ) {
    buttons[button_index++] = new RectButton( offX + i * matrix.rad + matrix.border / 2, offY + matrix.width() + offset, matrix.rad - matrix.border, button_size, button_color, button_color_over );
  } 
  buttons[button_index++] = new SquareButton( offX + matrix.width() + offset, offY + matrix.width() + offset, button_size, button_color, button_color_over ); 
}

void draw()
{
  if(update) {
  background(41);
  image(matrix.current_frame_image(), offX, offY);
  for(int i = 0; i < buttons.length; i++ ) {
    if( buttons[i] != null ) buttons[i].display();
  }
  
  draw_thumb_frames(); 
   
//   fill(255); //white
   //textFont(fontA, 20);
   
   /* String txt_mode = (record) ? "Record" : "Play";
   text( "Mode: " + txt_mode, offX + matrix.width() + 40, 40);
   
   String ard = (arduino.standalone) ? "Free" : "Ctrl";
   text( "Arduino: " + ard, offX + matrix.width() + 40, 60 );
   */
  // text( "Color: ", offX + matrix.width() + 40, 360 );
  //fill(matrix.current_frame().last_color.get_color()); //white
   
   
//   fill(255); //white
   //text( "Speed: " + current_speed, offX + matrix.width() + 55, 660);
   update = false;
  }
  next_frame();
}

void draw_thumb_frames() {
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
  update = true;
}

void mousePressed() {
  for(int i = 0; i < buttons.length; i++ ) {
    if( buttons[i] != null ) buttons[i].pressed();
  }  
  if(!record) return;
  arduino.write_frame( matrix.click(mouseX - offX, mouseY - offY) );
  update = true;
}

void mouseMoved() {
  for(int i = 0; i < buttons.length; i++ ) {
    if( buttons[i] != null ) update = update || buttons[i].over();
  }
  update = true;
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
    if( keyCode == 32) matrix.current_frame().fill();      //Space
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
  update = true;
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


