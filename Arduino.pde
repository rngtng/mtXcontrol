import processing.serial.*;

class Arduino {
  int BAUD_RATE  = 14400;

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

  Arduino(PApplet app) {
    try {
      port =  new Serial(app, Serial.list()[0], BAUD_RATE);
    }
    catch( Exception e) {
      port = null;
    }
    standalone = true;
  }


  /* +++++++++++++++++++++++++++ */

  void write_frame(Frame frame) {
    if(standalone) return;
    command( WRITE_FRAME );

    for(int y=0; y<frame.rows; y++) {
      send(frame.get_row(y));
    }
  }

  void write_matrix(Matrix matrix) {
    print("Start Writing Matrix - ");
    command( WRITE_EEPROM );
    send(matrix.num_frames());
    send(matrix.cols*3);

    for(int f=0; f< matrix.num_frames(); f++) {
      Frame frame = matrix.frame(f);
      for(int row=0; row<frame.rows; row++) {
        send(frame.get_row(row));
        delay(1); //we need this delay to give Arduino time consuming the Byte
      }      
    }
    println("Done");
  }

  Matrix read_matrix() {
    print("Start Reading Matrix - ");
    command( READ_EEPROM );
    int frames = wait_and_read_serial();   
    println( "Frames:" + frames);
    int cols  = wait_and_read_serial();
    Matrix matrix = new Matrix(rows, cols);

    println( "Rows: " + rows);
    for( int frame_nr = 0; frame_nr < frames; frame_nr++ ) 
    {      
      println("Frame Nr: " + frame_nr);
      String[] data = new String[cols];
      for( int row = 0; row < cols; row++ ) {
        data[row] = Integer.toString(wait_and_read_serial() );
      }
      //      matrix.add_frame(data);
    }
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

  private void send(Pixel[] pix) {
    int r = 0;
    int g = 0;
    int b = 0;
    for(int i = 0; i < pix.length; i++) {
      r |= (pix[i].r + 1) << (i+1);
      g |= (pix[i].g + 1) << (i+1);
      b |= (pix[i].b + 1) << (i+1);
    }
    send(~r);
    send(~g);
    send(~b);    
    delay(1);
  }

  private void send(int value) {
    if( port == null ) return;
    port.write(value);
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


