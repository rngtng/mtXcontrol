import processing.serial.*;

class Arduino {
  int BAUD_RATE  = 9600;

  int CRTL  = 255;
  int RESET = 255;

  int WRITE_FRAME  = 253;
  int WRITE_EEPROM = 252;
  int READ_EEPROM  = 251;

  int SPEED = 249;
  int SPEED_INC = 128; //B1000 0000
  int SPEED_DEC = 1;   //B0000 0001

  Serial port;

  public boolean standalone = true;

  boolean mirror_cols = true;
  boolean mirror_rows = true;

  Arduino(PApplet app) {
    try {
      port = new Serial(app, Serial.list()[0], BAUD_RATE);
    }
    catch(Exception e) {
      port = null;
    }
    standalone = true;
  }


  /* +++++++++++++++++++++++++++ */

  void write_frame(Frame frame) {
    if(frame == null || standalone) return;
    command( WRITE_FRAME );
    send_frame(frame);
  }

  void write_matrix(Matrix matrix) {
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

  Matrix read_matrix() {
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
        frame.set_row(y, wait_and_read_serial(), wait_and_read_serial(), wait_and_read_serial());
      }
      frame = matrix.add_frame();
    }
    matrix.delete_frame();
    println("Done");
    return matrix;
  }

  void toggle(Frame frame) {
    if(standalone) {
      standalone = false;
      write_frame(frame);
      return;
    }
    command(RESET);
    standalone = true;
  }

  void speed_up() {
    if(!standalone) return;
    command(SPEED);
    send(SPEED_INC);
  }

  void speed_down() {
    if(!standalone) return;
    command(SPEED);
    send(SPEED_DEC);
  }

  /* +++++++++++++++++++ */

  private void command( int command ) {
    send(CRTL);
    send(command);
  }

  private void send(int value) {
    if(port == null ) return;
    port.write(value);
  }

  private void send_row(byte[] row) {
    for(int i = 0; i < row.length; i++) {
      send(mirror_cols ? row[i] : ~row[i]);
    }
    delay(1);
  }

  void send_frame(Frame frame) {
    for(int y = 0; y < frame.rows; y++) {
      send_row(frame.get_row( mirror_rows ? (frame.rows - y - 1) : y ));
    }
  }

  private int wait_and_read_serial() {
    int cnt = 0;
    while( port.available() < 1 ) {
      delay( 1 );
      cnt++;
    }
    return port.read();
  }
}
