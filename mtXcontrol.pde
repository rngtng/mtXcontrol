
PFont fontA;
PFont fontLetter;

Matrix matrix;
Arduino arduino;

int border = 10;

int offY = 30;
int offX = 30;

int current_delay = 0;
int current_speed = 15;

boolean record  = true;
boolean keyCtrl = false;
boolean keyMac  = false;
boolean keyAlt  = false;

boolean update = true;
Button[] buttons;
Button botton_color;

int hide_button_index;

/* +++++++++++++++++++++++++++++ */

void setup() {
  matrix = new Matrix(8, 8);
  arduino = new Arduino(this);
  size(780,720 ); //size(2*offX + matrix.width(), 2*offY + matrix.height() );
  smooth();
  noStroke();
  fontA = loadFont("Courier-Bold-32.vlw");
  fontLetter = loadFont("ArialMT-20.vlw");
  setup_buttons();
}

void setup_buttons() {
  buttons = new Button[35]; // width + height + ???
  int offset = 10;
  int button_index = 0;
  int y_pos = 0;

  color button_color = #333333;
  color button_color_over = #999999;
  int button_size = 15;

  for(int i = 0; i < matrix.rows; i++ ) {
    buttons[button_index++] = new RectButton( offX + matrix.width() + offset, offY + i * matrix.rad + matrix.border / 2, button_size, matrix.rad - matrix.border, button_color, button_color_over);
  }
  for(int i = 0; i < matrix.cols; i++ ) {
    buttons[button_index++] = new RectButton( offX + i * matrix.rad + matrix.border / 2, offY + matrix.width() + offset, matrix.rad - matrix.border, button_size, button_color, button_color_over);
  }
  buttons[button_index++] = new SquareButton( offX + matrix.width() + offset, offY + matrix.width() + offset, button_size, button_color, button_color_over );

  buttons[button_index++] = new ActionToggleButton( "Mode: RECORD",  "Mode: PLAY",    "10",   offX + matrix.width() + offset + 30, y_pos += 30);
  buttons[button_index++] = new ActionToggleButton( "Arduino: FREE", "Arduino: CTRL", "a+10", offX + matrix.width() + offset + 30, y_pos += 30);

  hide_button_index = button_index;
  buttons[button_index++] = new ActionButton( "Load",  "L", offX + matrix.width() + offset + 30, y_pos += 50);
  buttons[button_index++] = new ActionButton( "Save",  "S", offX + matrix.width() + offset + 30, y_pos += 30);

  buttons[button_index++] = new ColorButton( offX + matrix.width() + offset + 30, y_pos += 50);

  buttons[button_index++] = new ActionButton( "Add",    " ", offX + matrix.width() + offset + 30, y_pos += 50);
  buttons[button_index++] = new ActionButton( "Delete", "D", offX + matrix.width() + offset + 30, y_pos += 30);

  buttons[button_index++] = new ActionButton( "^",      "c+38", offX + matrix.width() + offset + 75,  y_pos += 50,  40, 25);
  buttons[button_index++] = new ActionButton( "<",      "c+37", offX + matrix.width() + offset + 30,  y_pos += 20,  40, 25);
  buttons[button_index++] = new ActionButton( ">",      "c+39", offX + matrix.width() + offset + 120, y_pos, 40, 25);
  buttons[button_index++] = new ActionButton( "v",      "c+40", offX + matrix.width() + offset + 75,  y_pos += 15,  40, 25);

  buttons[button_index++] = new ActionButton( "Copy",   "m+C", offX + matrix.width() + offset + 30, y_pos += 50);
  buttons[button_index++] = new ActionButton( "Paste",  "m+V", offX + matrix.width() + offset + 30, y_pos += 30);
  buttons[button_index++] = new ActionButton( "Fill",   "F", offX + matrix.width() + offset + 30, y_pos += 30);
  buttons[button_index++] = new ActionButton( "Clear",  "C", offX + matrix.width() + offset + 30, y_pos += 30);
}

void draw()
{
  if(update) {
    background(41);
    image(matrix.current_frame_image(), offX, offY);
    for(int i = 0; i < buttons.length; i++ ) {
      if(buttons[i] != null) buttons[i].display( !record && i >= hide_button_index );
    }
    if(!record) {
      fill(255); //white
      text( "Speed: " + current_speed, offX + matrix.width() + 65, 110);
    }
    draw_thumb_frames(0, offY + matrix.height() + 40, 59);
    arduino.write_frame(matrix.current_frame());
    update = false;
  }
  if(!record) next_frame();
}

void draw_thumb_frames(int img_x, int img_y, int img_width) {
  int i;
  for(int x = 0; x < 10; x++) {
    i = ( matrix.current_frame_nr > 9 ) ? (matrix.current_frame_nr - 9 + x) : x;
    img_x = offX + img_width * x ;
    noFill();
    stroke( (i == matrix.current_frame_nr) ? #FFFF00 : #111111 );
    rect(img_x + 5, img_y, img_width - 10, img_width - 10);
    if( i < 0 || i >= matrix.num_frames()) continue;
    image( matrix.frame(i).draw_thumb(6, 4), img_x + 6, img_y + 1);
    fill(255); //white
    noStroke();
    textFont(fontA, 15);
    text(i + 1, img_x + 25, img_y + 62);
  }
}

/* +++++++++++++++++++++++++++++ */

void next_frame() {
  if(current_delay < 1) {
    current_delay = current_speed;
    matrix.next_frame();
    update = true;
  }
  current_delay--;
}

/* +++++++++++++++ ACTIONS +++++++++++++++ */
void mouseDragged() {
  if(!record) return;
  update = update || matrix.click(mouseX - offX, mouseY - offY, true);
}

void mousePressed() {
  for(int i = 0; i < buttons.length; i++ ) {
    if( buttons[i] != null ) update = update || buttons[i].pressed();
  }
  if(!record) return;
  update = matrix.click(mouseX - offX, mouseY - offY, false) || update;
}

void mouseMoved() {
  for(int i = 0; i < buttons.length; i++ ) {
    if( buttons[i] != null ) update = update || buttons[i].over();
  }
}

void keyPressed() {
  if(keyCode == 17)  keyCtrl = true; //control
  if(keyCode == 18)  keyAlt  = true; //alt
  if(keyCode == 157) keyMac  = true; //mac

  for(int i = 0; i < buttons.length; i++ ) {
    if(buttons[i] != null ) update = update || buttons[i].key_pressed(keyCode, keyMac, keyCtrl, keyAlt);
  }

  if(keyAlt) {
    if(keyCode == 37) arduino.speed_up();   //arrow left
    if(keyCode == 39) arduino.speed_down(); //arrow right
  }
  else if(keyCtrl) {
    if(keyCode >= 48) matrix.current_frame().set_letter(char(keyCode), fontLetter, matrix.current_color);
    update = true;
  }
  else {
    if(record) {
      if( keyCode == 37) matrix.previous_frame(); // arrow left
      if( keyCode == 39) matrix.next_frame();     // arrow right
      update = true;
    }
    else {
      if( keyCode == 37) speed_up();     //arrow left
      if( keyCode == 39) speed_down();   //arrow right
    }
  }
  println("pressed " + key + " " + keyCode);
}

void keyReleased() {
  if( keyCode == 17 )  keyCtrl = false;
  if( keyCode == 18 )  keyAlt  = false;
  if( keyCode == 157 ) keyMac  = false;
}

/* +++++++++++++++ modes +++++++++++++++ */

void toggle_mode() {
  matrix.current_frame_nr = 0;
  record = !record;
}

void speed_up() {
  if( current_speed < 2 ) return;
  current_speed--;
}

void speed_down() {
  current_speed++;
}


