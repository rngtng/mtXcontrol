import processing.serial.*;

/*
class RainbowduinoDevice implements Device, StandaloneDevice {

  public Rainbowduino rainboduino;
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
    rainboduino = new Rainboduino(app);
    rainboduino.init(port_name, baud_rate);
  }

  /* +++++++++++++++++++++++++++ /

  public void write_frame(Frame frame) {
    if(frame == null || standalone) return;
    command( WRITE_FRAME );
    send_frame(frame);
  }

  public void write_matrix(Matrix matrix) {
    print("Start Writing Matrix - ");
    write_frame(matrix.frame(0));
    command( WRITE_EEPROM );
    send(matrix.num_frames());
    //send(matrix.rows*3);
    for(int f = 0; f < matrix.num_frames(); f++) {
      send_frame(matrix.frame(f));
    }
    println("Done");
  }

  public Matrix read_matrix() {
    PixelColor pc;
    if(standalone) toggle(matrix.current_frame());
    print("Start Reading Matrix - ");
    command( READ_EEPROM );
    int frames = wait_and_read_serial();
    println( "Frames:" + frames);
    // int cols  = wait_and_read_serial();
    Matrix matrix = new Matrix(8,8);
    Frame frame = matrix.current_frame();
    for( int frame_nr = 0; frame_nr < frames; frame_nr++ )
    {
      println("Frame Nr: " + frame_nr);
      for( int y = frame.rows - 1; y >= 0; y-- ) {
        pc = new PixelColor(wait_and_read_serial(), wait_and_read_serial(), wait_and_read_serial());
        frame.set_row(y, pc);
      }
      frame = matrix.add_frame();
    }
    matrix.delete_frame();
    println("Done");
    return matrix;
  }

  public void toggle(Frame frame) {
    if(standalone) {
      standalone = false;
      write_frame(frame);
      return;
    }
    command(RESET);
    standalone = true;
  }

  private void write_frame(Frame frame) {
    for(int y = 0; y < frame.rows; y++) {
      send_row(frame.get_row( mirror_rows ? (frame.rows - y - 1) : y ));
    }
  }

  public void speed_up() {
    if(!standalone) return;
    command(SPEED);
    send(SPEED_INC);
  }

  public void speed_down() {
    if(!standalone) return;
    command(SPEED);
    send(SPEED_DEC);
  }

  boolean enabled() {
    return enabled;
  }  
}


*/



