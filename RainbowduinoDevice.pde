import processing.serial.*;
import com.rngtng.rainbowduino.*;

class RainbowduinoDevice implements Device, StandaloneDevice {

  public Rainbowduino rainbowduino;

  public boolean running;

  int bright = 16;

  RainbowduinoDevice(PApplet app) {
    RainbowduinoDetector.start(app, true);
    this.rainbowduino = null;
  }

  public void init(Rainbowduino _rainbowduino) {
    rainbowduino = _rainbowduino;
    rainbowduino.brightnessSet(this.bright);
    rainbowduino.reset();
    rainbowduino.stop();
    running = false;
  }

  void setColorScheme() {
    PixelColorScheme.R = new int[]{
      0,255            };
    PixelColorScheme.G = new int[]{
      0,255            };
    PixelColorScheme.B = new int[]{
      0,255            };
  }

  boolean draw_as_circle() {
    return true;
  }

  boolean enabled() {
    return (this.rainbowduino != null);
  }

  /* +++++++++++++++++++++++++++ */
  public void write_frame(Frame frame) {
    write_frame(0, frame);
  }

  public void write_frame(int num, Frame frame) {
    if(frame == null || running || !enabled() ) return;
    int slave_nr = 0;
    for( int y = 0; y < frame.rows; y += rainbowduino.height ) {
      for( int x = 0; x < frame.cols; x += rainbowduino.width ) {
        //rainbowduino.slaveActiv(slave_nr += 1);
        rainbowduino.bufferSetAt(num, get_frame_rows(frame, x, y));
      }
    }
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
    int frames =  rainbowduino.bufferLoad(); //return num length
    println( "Frames:" + frames);

    for( int frame_nr = 0; frame_nr < frames; frame_nr++ ) {
      //println("Frame Nr: " + frame_nr);
      Frame frame = matrix.current_frame();
      int frame_byte[] = rainbowduino.bufferGetAt(frame_nr);
      for(int y = 0; y < 8; y++ ) {
        for(int x = 0; x < 8; x++ ) {
          int[] ab = xy2ab(x,y);
          frame.set_pixel(ab[0], ab[1], new PixelColor((frame_byte[3*y+0] >> x) & 1, (frame_byte[3*y+1] >> x) & 1, (frame_byte[3*y+2] >> x) & 1 ) );
        }
      }
      matrix.add_frame();
    }
    matrix.delete_frame();
    println("Done");
    return matrix;
  }

  public void toggle() {
    if(running) {
      running = false;
      rainbowduino.reset();
      return;
    }
    running = true;
    rainbowduino.bufferLoad();
    rainbowduino.start();
  }

  public void speedUp() {
    rainbowduino.speedUp();
  }

  public void speedDown() {
    rainbowduino.speedDown();
  }

  public void brightnessUp() {
    this.bright++;
    rainbowduino.brightnessSet(this.bright);
  }

  public void brightnessDown() {
    this.bright--;
    if(this.bright < 1) this.bright = 1;
    rainbowduino.brightnessSet(this.bright);
  }

  private int[] xy2ab(int x, int y) {
    return new int[]{x, y};
  }

  private int[] ab2xy(int a, int b) {
    return new int[]{a, b};
  }

  ////////////////////////////////////////////////////
  protected int[] get_frame_rows(Frame frame, int x_off, int y_off) {
    int[] res = new int[3*frame.rows];
    for( int y = 0; y < rainbowduino.height; y++ ) {
      for( int x = 0; x < rainbowduino.width; x++ ) {
        PixelColor p = frame.get_pixel(x + x_off, y + y_off);
        int[] ab = xy2ab(x,y);
        res[3*ab[1] + 0] |= (p.r & 1) << ab[0];
        res[3*ab[1] + 1] |= (p.b & 1) << ab[0];
        res[3*ab[1] + 2] |= (p.g & 1) << ab[0];
      }
    }
    return res;
  }
}










