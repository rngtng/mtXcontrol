
class RainbowduinoDevice implements Device, StandaloneDevice {

  public Rainbowduino rainbowduino;
  public boolean enabled = false;

  public boolean standalone = true;


  private boolean mirror_cols = true;
  private boolean mirror_rows = true;

  RainbowduinoDevice(PApplet app) {
    this(app, null, 0);
  }

  RainbowduinoDevice(PApplet app, String port_name) {
    this(app, port_name, 0);
  }

  RainbowduinoDevice(PApplet app, int baud_rate) {
    this(app, null, baud_rate);
  }

  RainbowduinoDevice(PApplet app, String port_name, int baud_rate) {
    rainbowduino = new Rainbowduino(app);
    rainbowduino.init(port_name, baud_rate);
  }

  /* +++++++++++++++++++++++++++ */
  public void write_frame(Frame frame) {    
    write_frame(0, frame);
  }

  public void write_frame(int num, Frame frame) {    
    if(frame == null || standalone) return;
    rainbowduino.bufferSetAt(num, get_frame_rows(frame));
  }

  public void write_matrix(Matrix matrix) {
    print("Start Writing Matrix - ");
    for(int f = 0; f < matrix.num_frames(); f++) {
      write_frame(f, matrix.frame(f));
    }
    rainbowduino.bufferSave();
    println("Done");
  }

  public Matrix read_matrix() {
    Matrix matrix = new Matrix(8,8);

    print("Start Reading Matrix - ");
    int frames = rainbowduino.bufferLoad(); //return num length
    println( "Frames:" + frames);

    for( int frame_nr = 0; frame_nr < frames; frame_nr++ ) {    
      println("Frame Nr: " + frame_nr);
      Frame frame = matrix.current_frame();
      frame.set_pixels( rainbowduino.bufferGetAt(frame_nr) );
      matrix.add_frame();
    }           
    matrix.delete_frame();
    println("Done");
    return matrix;
  }

  public void toggle() {
    rainbowduino.reset();
    if(standalone) {
      standalone = false;
      rainbowduino.start();
      return;
    }    
    standalone = true;
  }

  public void speed_up() {
    rainbowduino.speedUp();
  }

  public void speed_down() {
    rainbowduino.speedDown();
  }

  boolean enabled() {
    return true;
  }  

  ////////////////////////////////////////////////////  
  private byte[] get_frame_rows(Frame frame) {
    byte[] res = new byte[3*frame.rows];
    for( int y = 0; y < frame.rows; y++ ) {
      for( int x = 0; x < frame.cols; x++ ) {
        PixelColor p = frame.get_pixel(x,y);
        res[3*y + 0] |= (p.r & 1) << x;
        res[3*y + 1] |= (p.g & 1) << x;
        res[3*y + 2] |= (p.b & 1) << x;
      }
    }  
    return res;  
  }
}






