import processing.serial.*;

class RainbowduinoDevice implements Device, StandaloneDevice {
  final static int DEFAULT_BAUD_RATE  = 9600;

  int CRTL  = 255;
  int RESET = 255;

  int PING = 254;
  int HELLO = 254;

  int WRITE_FRAME  = 253;
  int WRITE_EEPROM = 252;
  int READ_EEPROM  = 251;

  int SPEED = 249;
  int SPEED_INC = 128; //B1000 0000
  int SPEED_DEC = 1;   //B0000 0001

  int baud;
  
  ArrayList buffer;
  Serial port;
  String port_name;

  public boolean standalone = true;
  public boolean enabled = false;

  private boolean mirror_cols = true;
  private boolean mirror_rows = true;

  RainbowduinoDevice() {
    this(DEFAULT_BAUD_RATE);
  }

  RainbowduinoDevice(String _port_name) {
    this(_port_name, DEFAULT_BAUD_RATE);
  }

  RainbowduinoDevice(int _baud) {
    this(null, _baud);
  }

  RainbowduinoDevice(String _port_name, int _baud) {
    port_name = _port_name;
    baud = _baud;
    buffer = new ArrayList();
    port = null;
    standalone = true;
  }

  public void start(PApplet app) {
     if(port_name != null) standalone = set_port(app, port_name);
     if( port == null ) {
       String[] ports = Serial.list();       
       for(int i = 0; i < ports.length; i++) {
         if(match(ports[i], "tty") == null) continue;
         enabled = set_port(app, ports[i]);
         if(enabled) return;
       }
     }
     standalone = false;
  }

  public boolean set_port(PApplet app, String port_name) {
      println(port_name);
      try {
        port = new Serial(app, port_name, this.baud);
        port.buffer(0);
        if(wait_and_read_serial(20) == 252) {
          command(PING);
          if(wait_and_read_serial(20) == HELLO) return true;         
          port.stop();
        }
        println("No response");        
      }
      //catch(gnu.io.PortInUseException e) {
      //}
      catch(Exception e) {
         println("Failed");
        //if(port != null) port.stop();
      }
    port = null;
    return false;
  }

  /* +++++++++++++++++++++++++++ */

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

  public void received(int l) {
    buffer.add(l);
  }

  boolean enabled() {
    return enabled;
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
    delay(2);
  }

  private void send_frame(Frame frame) {
    for(int y = 0; y < frame.rows; y++) {
      send_row(frame.get_row( mirror_rows ? (frame.rows - y - 1) : y ));
    }
  }

  private int wait_and_read_serial() {
    try {
      return wait_and_read_serial(50);
    }
    catch( Exception e) {  
      println("Matrix Timeout");
      return 0;
    }
  }

  private int wait_and_read_serial(int timeout) throws Exception {
    int cnt = 0;
    timeout = timeout;
    while( cnt < timeout && buffer.size() < 1) {
      //print(".");
      sleep(100);
      cnt++;
      if(cnt > timeout) throw new Exception();
    }
    return int( (Integer) buffer.remove(0));
  }

  private void sleep(int ms) {
    try {
      Thread.sleep(ms);
    }
    catch(InterruptedException e) {
    }
  }
}





