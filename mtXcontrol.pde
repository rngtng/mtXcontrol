/*
 * mtXcontrol - a LED Matrix Editor - version 1.2
 *
 * By now this application supports Novation launchpad and Seeedstudion Rainbowduino. For both device additional
 * libraries are needed:
 *
 * For launchad get the processing library here: http://rngtng.github.com/launchpad
 * For rainbowduino get the processing library here: http://rngtng.github.com/rainbowduino. 
 *
 * Alternatively, you could delete the accordant device files LaunchpadDevice.pde / RainbowduinoDevice.pde and
 * its object instantiation arround line 50 in this file
 *
 * See Readme.markdown for more
 *
 */
PFont fontA;
PFont fontLetter;

Matrix matrix;
Device device;

int offY = 55;
int offX = 15;

int current_delay = 0;
int current_speed = 10;

boolean record  = true;
boolean color_mode  = false;

boolean keyCtrl = false;
boolean keyMac  = false;
boolean keyAlt  = false;

boolean update = true;
Button[] buttons;

int hide_button_index;

PixelColor global_color = new PixelColor();

/* +++++++++++++++++++++++++++++ */

void setup() {
  frame.setIconImage( getToolkit().getImage("sketch.ico") );
  
  //Device instantiation, try to find Launchpad first, fallback to Rainbowduino
  device = new LaunchpadDevice(this); //delete this line (and LaunchpadDevice.pde) if no Launchpad support wanted
  if(device == null || !device.enabled()) device = new RainbowduinoDevice(this); //delete this line (and RainbowduinoDevice.pde) if no Rainbowduino support wanted

  device.setColorScheme();

  matrix = new Matrix(8,8);

  size(980,720);
  smooth();
  noStroke();
  fontA = loadFont("Courier-Bold-32.vlw");
  fontLetter = loadFont("ArialMT-20.vlw");
  setup_buttons();
  frameRate(15);
}

void setup_buttons() {
  buttons = new Button[160]; // width + height + ???
  int offset = 10;
  int button_index = 0;
  int y_pos = 10;

color button_color = #333333;
color button_color_over = #999999;
  int button_size = 15;

  for(int i = 0; i < matrix.rows; i++ ) {
    int x = offX + matrix.width() + offset;
    int y = offY + i * matrix.rad + matrix.border / 2;
    buttons[button_index++] = new RectButton( x, y, button_size, matrix.rad - matrix.border, button_color, button_color_over);
  }
  for(int i = 0; i < matrix.cols; i++ ) {
    int x = offX + i * matrix.rad + matrix.border / 2;
    int y = offY + matrix.height() + offset;
    buttons[button_index++] = new RectButton( x, y, matrix.rad - matrix.border, button_size, button_color, button_color_over);
  }
  buttons[button_index++] = new SquareButton( offX + matrix.width() + offset, offY + matrix.width() + offset, button_size, button_color, button_color_over );

  int button_x = offset; //offX + matrix.width() + offset + 30;
  buttons[button_index++] = new ActionToggleButton( "Mode: RECORD", "Mode: PLAY", "10",   button_x, y_pos);

  buttons[button_index++] = new TextElement( "Load from:",      button_x += 150, y_pos);
  buttons[button_index++] = new ActionButton( "File",    "m+L", button_x += 100, y_pos, 65, 25);
  buttons[button_index++] = new ActionButton( "Device",  "a+L", button_x += 67,  y_pos, 65, 25);
  if(! (device instanceof StandaloneDevice && device.enabled()) ) buttons[button_index-1].disable();

  buttons[button_index++] = new TextElement( "Save to:",        button_x += 100, y_pos);
  buttons[button_index++] = new ActionButton( "File",    "m+S", button_x += 80, y_pos, 65, 25);
  buttons[button_index++] = new ActionButton( "Device",  "a+S", button_x += 67,  y_pos, 65, 25);
  if(! (device instanceof StandaloneDevice && device.enabled()) ) buttons[button_index-1].disable();

  buttons[button_index++] = new ActionToggleButton( "Device: SLAVE",  "Device: FREE", "a+10", width - 150, y_pos);
  if(! (device instanceof StandaloneDevice && device.enabled()) ) buttons[button_index-1].disable();
  hide_button_index = button_index;
  
  buttons[button_index++] = new FrameChooser(offX, offY + matrix.height() + 40, matrix.width(), matrix.height());

  buttons[button_index++] = new TextElement( "Color:", button_x, y_pos += 140);
  y_pos += 30;

  PixelColor pc = new PixelColor(); 
  int off = 140 / pc.numColors();
  for(int r = 0; r < PixelColorScheme.R.length; r++) {
    for(int g = 0; g < PixelColorScheme.G.length; g++) {
      for(int b = 0; b < PixelColorScheme.B.length; b++) {   
        buttons[button_index++] = new MiniColorButton( button_x + pc.to_int() * off, y_pos, off, 20, pc.clone() );
        pc.next_color();
      }
    }
  }

  buttons[button_index++] = new TextElement( "Frame:", button_x, y_pos += 20);  
  buttons[button_index++] = new ActionButton( "Add",    " ", button_x, y_pos += 30);
  buttons[button_index++] = new ActionButton( "Delete", "D", button_x, y_pos += 30);

  buttons[button_index++] = new ActionButton( "^", "c+38", button_x + 47,  y_pos += 50, 40, 25);
  buttons[button_index++] = new ActionButton( "<", "c+37", button_x,       y_pos += 20, 40, 25);
  buttons[button_index++] = new ActionButton( ">", "c+39", button_x + 94,  y_pos,       40, 25);
  buttons[button_index++] = new ActionButton( "v", "c+40", button_x + 47,  y_pos += 15, 40, 25);

  buttons[button_index++] = new ActionButton( "Paste",  "m+V", button_x, y_pos += 50);
  buttons[button_index++] = new ActionButton( "Copy",   "m+C", button_x, y_pos += 30);
  buttons[button_index++] = new ActionButton( "Fill",   "F",   button_x, y_pos += 30);
  buttons[button_index++] = new ActionButton( "Clear",  "X",   button_x, y_pos += 30);
}

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

void draw()
{  
  if(update) {
    background(45);
    fill(50);
    rect(offX - matrix.border / 2, offY - matrix.border / 2, matrix.width() + matrix.border, matrix.height() + matrix.border);
    image(matrix.current_frame_image(), offX, offY);
    
    for(int i = 0; i < buttons.length; i++ ) {
      if(buttons[i] == null) break;
      buttons[i].display();
    }

    fill(255); //white
    if(!record) {
      text("Speed: " + current_speed, offX + matrix.width() + 65, 110);
    }

    if(!device.enabled()) {
      text("No output device found, running in standalone mode", 120, 220);  
    }

    device.write_frame(matrix.current_frame());
    update = false;
  }
  if(!record) next_frame();
}


/* +++++++++++++++++++++++++++++ */

void next_frame() {
  if(current_delay < 1) {
    current_delay = current_speed;
    matrix.next_frame();
    mark_for_update();
  }
  current_delay--;
}

/* +++++++++++++++ ACTIONS +++++++++++++++ */
void mouseDragged() {
  if(!record) return;
  if(matrix.click(mouseX - offX, mouseY - offY, global_color, true)) mark_for_update();
}

void mousePressed() {
  if(!record) return;
  if(matrix.click(mouseX - offX, mouseY - offY, global_color, false)) mark_for_update();
}

void mouseMoved() {
  for(int i = 0; i < buttons.length; i++ ) {
    if(buttons[i] == null) break;
    if(buttons[i].over()) mark_for_update();
  }
}

void mouseClicked() {
  for(int i = 0; i < buttons.length; i++ ) {
    if(buttons[i] == null) break;
    if(buttons[i].clicked()) mark_for_update();
  }
}


void keyPressed() {
  if(keyCode == 17)  keyCtrl = true; //control
  if(keyCode == 18)  keyAlt  = true; //alt
  if(keyCode == 157) keyMac  = true; //mac
  if(keyCode == 67) color_mode = true; //C
  
  //println("pressed " + key + " " + keyCode + " " +keyMac+ " "+  keyCtrl + " "+ keyAlt );

  if(color_mode && !keyMac) {
     if(keyCode == 37) { global_color.previous_color(); mark_for_update(); return;}//arrow left
     if(keyCode == 39) { global_color.next_color();  mark_for_update(); return;} //arrow right   
  }

  for(int i = 0; i < buttons.length; i++ ) {
    if(buttons[i] == null) break;
    if(buttons[i].key_pressed(keyCode, keyMac, keyCtrl, keyAlt)) {
      mark_for_update();  
      return;
    }
  }
   
  if(keyAlt) {
    if(device instanceof StandaloneDevice) {
      if(keyCtrl) {
        if(keyCode == 37) ((StandaloneDevice) device).brightnessDown();   //arrow left
        if(keyCode == 39) ((StandaloneDevice) device).brightnessUp(); //arrow right        
      }
      else {        
        if(keyCode == 37) ((StandaloneDevice) device).speedUp();   //arrow left
        if(keyCode == 39) ((StandaloneDevice) device).speedDown(); //arrow right        
      }
    }
  }
  else if(keyCtrl) {
    if(keyCode >= 48 ) {
      if( matrix.current_frame().set_letter(char(keyCode), fontLetter, global_color) )  mark_for_update();
      return;
    }
  }
  else {
    if(!record) {
      if( keyCode == 37) speed_up();     //arrow left
      if( keyCode == 39) speed_down();   //arrow right
    }
  }
}

void keyReleased() {
  if( keyCode == 17 )  keyCtrl = false;
  if( keyCode == 18 )  keyAlt  = false;
  if( keyCode == 157 ) keyMac  = false;
  if( keyCode == 67 ) color_mode = false;
}

void rainbowduinoAvailable(Rainbowduino rainbowudino) {
    matrix = new Matrix( (Device) rainbowudino);
}

/* +++++++++++++++ modes +++++++++++++++ */

void mark_for_update() {
  update = true;
}

/* +++++++++++++++ modes +++++++++++++++ */
void toggle_mode() {
  matrix.current_frame_nr = 0;
  record = !record;
  for(int i = hide_button_index; i < buttons.length; i++ ) {
    if(buttons[i] == null) break;
    if(record) buttons[i].toggle(); 
    else buttons[i].hide();
  }
  if(record) buttons[hide_button_index-1].enable(); 
  else buttons[hide_button_index-1].disable();
}

void speed_up() {
  if( current_speed < 2 ) return;
  current_speed--;
}

void speed_down() {
  current_speed++;
}







