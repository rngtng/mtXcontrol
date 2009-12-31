import themidibus.*;
import com.rngtng.launchpad.*;

class LaunchpadDevice implements Device, LaunchpadListener { 

  public Launchpad launchpad;

  private LColor[] buttonColors = new LColor[16];

  boolean colorButtonPressed = false;

  LaunchpadDevice(PApplet app) {
    launchpad = new Launchpad(app);   
    if(enabled()) launchpad.addListener(this);
  }

  void setColorScheme() {
    PixelColorScheme.R = new int[]{
      0,105,170,255        };   
    PixelColorScheme.G = new int[]{
      0,105,170,255        };   
    PixelColorScheme.B = new int[]{
      0        };   
  }

  boolean draw_as_circle() {
    return false;
  }

  boolean enabled() {
    return launchpad.connected();
  }

  /* +++++++++++++++++++++++++++ */
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

    if( record ) {
      colors[72] = new LColor(LColor.GREEN_LOW);
      colors[73] = new LColor(LColor.GREEN_LOW);     

      colors[76] = new LColor(LColor.RED_LOW);
      colors[77] = new LColor(LColor.RED_LOW);     

      colors[78] = new LColor(matrix.current_color.r, matrix.current_color.g);
      colors[79] = new LColor(LColor.GREEN_LOW); 
    }
    else {
      colors[79] = new LColor(LColor.RED_LOW); 
    } 

    colors[74] = new LColor(LColor.YELLOW_LOW);
    colors[75] = new LColor(LColor.YELLOW_LOW); 

    launchpad.bufferingMode(Launchpad.BUFFER0, Launchpad.BUFFER0);
    launchpad.changeAll(colors);

    if(colorButtonPressed) {
      launchpad.bufferingMode(Launchpad.BUFFER0, Launchpad.BUFFER1, Launchpad.MODE_COPY);
      launchpad.changeSceneButton(LButton.sceneButtonCode(matrix.current_color.r+1), LColor.YELLOW_MEDIUM + LColor.BUFFERED);
      launchpad.changeSceneButton(LButton.sceneButtonCode(matrix.current_color.g+5), LColor.YELLOW_MEDIUM + LColor.BUFFERED);      
    }    
    launchpad.flashingAuto();
  }

  //////////////////////////////    Listener   ////////////////////////////////////
  public void launchpadGridPressed(int x, int y) {
    if(!record) return;
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
    if(!record) return;
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
    if( record ) {
      if(buttonCode == LButton.UP)      matrix.add_frame();
      if(buttonCode == LButton.DOWN)    matrix.delete_frame();
      if(buttonCode == LButton.LEFT)    matrix.previous_frame();
      if(buttonCode == LButton.RIGHT)   matrix.next_frame();
      if(buttonCode == LButton.SESSION) matrix.copy_frame();
      if(buttonCode == LButton.USER1)   matrix.paste_frame();
      if(buttonCode == LButton.USER2)   colorButtonPressed = false;          
    }
    else {
      if(buttonCode == LButton.LEFT)    speed_up();
      if(buttonCode == LButton.RIGHT)   speed_down();
    }
    if(buttonCode == LButton.MIXER)   toggle_mode();
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

}




















