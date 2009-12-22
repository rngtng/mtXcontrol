
class LaunchpadDevice implements Device, LaunchpadListener { 

  public Launchpad launchpad;
  private boolean enabled;

  private LColor[] buttonColors = new LColor[16];

  boolean colorButtonPressed = false;

  LaunchpadDevice(PApplet app) {
    launchpad = new Launchpad(app);
    launchpad.flashing_auto();    
    launchpad.addListener(this);
    enabled = true;
  }

  void write_frame(Frame frame) {
    LColor[] colors = new LColor[80];
    for( int y = 0; y < frame.rows; y++ ) {
      for( int x = 0; x < frame.cols; x++ ) {
        PixelColor p = frame.get_pixel(x,y);
        colors[y * frame.cols + x] = new LColor(p.r, p.g); 
      }
    }
    if(colorButtonPressed) {
      for( int r = 0; r < 4; r++ ) {
        colors[64 + r] = new LColor(r);
        if(matrix.current_color.r == r ) colors[64 + r].setMode(LColor.BUFFERED);
      }
      for( int g = 0; g < 4; g++ ) {
        colors[68 + g] = new LColor(LColor.RED_OFF, g); 
        if(matrix.current_color.g == g ) colors[68 + g].setMode(LColor.BUFFERED);
      }     
    }
    
    colors[72] = new LColor(LColor.GREEN_LOW);
    colors[73] = new LColor(LColor.GREEN_LOW);     
    
    colors[74] = new LColor(LColor.YELLOW_LOW);
    colors[75] = new LColor(LColor.YELLOW_LOW); 
    
    colors[76] = new LColor(LColor.RED_LOW);
    colors[77] = new LColor(LColor.RED_LOW);     
    
    colors[78] = new LColor(matrix.current_color.r, matrix.current_color.g); 
    colors[79] = (record) ? new LColor(LColor.GREEN_LOW) : new LColor(LColor.RED_LOW); 
    
    launchpad.flashing_on();
    launchpad.changeAll(colors);
    
    if(colorButtonPressed) {
      launchpad.flashing_off();
      launchpad.changeSceneButton(LButton.sceneButtonCode(matrix.current_color.r+1), LColor.YELLOW_MEDIUM + LColor.BUFFERED);
      launchpad.changeSceneButton(LButton.sceneButtonCode(matrix.current_color.g+5), LColor.YELLOW_MEDIUM + LColor.BUFFERED);      
    }    
    launchpad.flashing_auto();
  }

  void write_matrix(Matrix matrix) {
  }

  void speed_up() {   
  }

  void speed_down() {   
  }

  boolean enabled() {
    return enabled;
  }

  public void received(byte l) {   
  }

  //////////////////////////////    Listener   ////////////////////////////////////
  public void launchpadGridPressed(int x, int y) {
    if(colorButtonPressed) {      
      matrix.current_color = matrix.current_frame().get_pixel(x, y).clone();
    }
    else {
      matrix.click(x * matrix.rad, y * matrix.rad, false);
    }
    mark_for_update();
  }  

  public void launchpadGridReleased(int x, int y) {
  }

  public void launchpadButtonPressed(int buttonCode) {
    if(buttonCode == LButton.USER2) {
      colorButtonPressed = true;
    }
    else {
      launchpad.changeButton(buttonCode, LColor.YELLOW_HIGH);      
    }
    mark_for_update();    
  }  

  public void launchpadButtonReleased(int buttonCode) {
    // launchpad.changeButton(buttonCode, c);
    switch(buttonCode) {
    case LButton.UP:
      matrix.add_frame();
      break;
    case LButton.DOWN:
      matrix.delete_frame();
      break;
    case LButton.LEFT:
      matrix.previous_frame();
      break;
    case  LButton.RIGHT:  
      matrix.next_frame();
      break;
    case  LButton.SESSION:        
      matrix.copy_frame();
      break;
    case  LButton.USER1: 
      matrix.paste_frame();    
      break;
    case  LButton.USER2:        
      colorButtonPressed = false;
      break;
    case  LButton.MIXER:        
      toggle_mode();
      break;      
    }
    mark_for_update();    
  }

  public void launchpadSceneButtonPressed(int button) {
    int number = LButton.sceneButtonNumber(button);
    if(colorButtonPressed) {
      if( number < 5) { 
        matrix.current_color.r = number - 1;
      } 
      else {
        matrix.current_color.g = number - 5;
      }
    }
    mark_for_update();
  }  

  public void launchpadSceneButtonReleased(int buttonCode) {
  }

  /*
  private LColor color_button(int buttonCode) {
   if( buttonCode == LButton.SCENE1) return new LColor(LColor.RED_HIGH,   LColor.GREEN_OFF);
   if( buttonCode == LButton.SCENE2) return new LColor(LColor.RED_MEDIUM, LColor.GREEN_OFF);
   if( buttonCode == LButton.SCENE3) return new LColor(LColor.RED_LOW,    LColor.GREEN_OFF);
   if( buttonCode == LButton.SCENE4) return new LColor(LColor.RED_OFF,    LColor.GREEN_OFF);
   if( buttonCode == LButton.SCENE5) return new LColor(LColor.RED_OFF,    LColor.GREEN_HIGH);
   if( buttonCode == LButton.SCENE6) return new LColor(LColor.RED_OFF,    LColor.GREEN_MEDIUM);
   if( buttonCode == LButton.SCENE7) return new LColor(LColor.RED_OFF,    LColor.GREEN_LOW);
   if( buttonCode == LButton.SCENE8) return new LColor(LColor.RED_OFF,    LColor.GREEN_OFF);
   return null;
   }  */

}















