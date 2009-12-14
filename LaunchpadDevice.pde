import themidibus.*;
import com.rngtng.launchpad.*; //Import the library

class LaunchpadDevice implements Device, LaunchpadListener { 

  public Launchpad launchpad;
  private boolean enabled;
  private PApplet parent;

  private LColor[] buttonColors = new LColor[16];

  LaunchpadDevice(PApplet app) {
    parent = app;
    launchpad = new Launchpad(app);
    launchpad.reset();
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
    for( int r = 0; r < 4; r++ ) {
      colors[64 + r] = (r == matrix.current_color.r) ? new LColor(LColor.RED_HIGH, LColor.GREEN_HIGH) : new LColor(r, 0);
    }
    for( int g = 0; g < 4; g++ ) {
      colors[68 + g] = (g == matrix.current_color.g) ? new LColor(LColor.RED_HIGH, LColor.GREEN_HIGH) : new LColor(0, g); 
    }     

    /* for( int y = 0; y < 8; y++ ) {
     colors[72 + y] = LColor(0,0); 
     } */

    launchpad.change_all(colors);
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

  ////////////////////////////// Listener 
  ////////////////////////////////////
  public void launchpadGridPressed(int x, int y) {
    if(matrix.click(x * matrix.rad, y * matrix.rad, false)) mark_for_update();
  }  

  public void launchpadGridReleased(int x, int y) {
  }

  public void launchpadButtonPressed(int buttonCode) {
    launchpad.changeButton(buttonCode, LColor.RED_HIGH, LColor.GREEN_HIGH);      
  }  

  public void launchpadButtonReleased(int buttonCode) {
    // launchpad.changeButton(buttonCode, c);
    if( buttonCode == Launchpad.BUTTON_UP) {
    }
    if( buttonCode == Launchpad.BUTTON_DOWN) {
    }  
    if( buttonCode == Launchpad.BUTTON_LEFT)   {
    }
    if( buttonCode == Launchpad.BUTTON_RIGHT) {
    }          
    mark_for_update();    
  }
 
  public void launchpadSceneButtonPressed(int buttonCode) {
    int number = Launchpad.sceneButtonCodeToNumber(buttonCode);
    if( number < 5) { 
       matrix.current_color.r = number - 1;
    } 
    else {
      matrix.current_color.g = number - 5;
    }
    mark_for_update();
  }  

  public void launchpadSceneButtonReleased(int buttonCode) {
  }

  /*
  private LColor color_button(int buttonCode) {
   if( buttonCode == Launchpad.BUTTON_SCENE1) return new LColor(LColor.RED_HIGH,   LColor.GREEN_OFF);
   if( buttonCode == Launchpad.BUTTON_SCENE2) return new LColor(LColor.RED_MEDIUM, LColor.GREEN_OFF);
   if( buttonCode == Launchpad.BUTTON_SCENE3) return new LColor(LColor.RED_LOW,    LColor.GREEN_OFF);
   if( buttonCode == Launchpad.BUTTON_SCENE4) return new LColor(LColor.RED_OFF,    LColor.GREEN_OFF);
   if( buttonCode == Launchpad.BUTTON_SCENE5) return new LColor(LColor.RED_OFF,    LColor.GREEN_HIGH);
   if( buttonCode == Launchpad.BUTTON_SCENE6) return new LColor(LColor.RED_OFF,    LColor.GREEN_MEDIUM);
   if( buttonCode == Launchpad.BUTTON_SCENE7) return new LColor(LColor.RED_OFF,    LColor.GREEN_LOW);
   if( buttonCode == Launchpad.BUTTON_SCENE8) return new LColor(LColor.RED_OFF,    LColor.GREEN_OFF);
   return null;
   }  */

}







