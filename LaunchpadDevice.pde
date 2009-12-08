import com.rngtng.launchpad.*; //Import the library

class LaunchpadDevice implements Device {
  
  public Launchpad device;
  private boolean enabled;
  
  LaunchpadDevice(PApplet app) {
    device = new Launchpad(app);
    device.reset();
    enabled = true;
  }

  void write_frame(Frame frame) {
    byte[] colors = new byte[80];
    for( int y = 0; y < frame.rows; y++ ) {
      for( int x = 0; x < frame.cols; x++ ) {
        PixelColor p = frame.get_pixel(x,y);
        colors[y * frame.cols + x] = byte(p.g * 16 + p.r); 
      }
    }
    device.change_all(colors);   
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

}

