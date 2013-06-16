
class Matrix {

  ArrayList frames  = new ArrayList();

  public int rad = 70;
  int border = 10;

  public int rows = 0;
  public int cols = 0;
  public PixelColor current_color;

  Frame copy_frame;

  int SCALE = 1;

  int current_frame_nr;

  Matrix(int cols, int rows ) {
    this.cols = cols; //X
    this.rows = rows; //Y
    this.current_color = new PixelColor();
    add_frame();
  }

  public int width() {
    return cols * rad;
  }

  public int height() {
    return rows * rad;
  }

  public PGraphics current_frame_image() {
    return this.current_frame_image(rad, border);
  }

  public PGraphics current_frame_image(int draw_rad, int draw_border) {
    return this.current_frame().draw_full(draw_rad, draw_border);
  }

  public boolean click(int x, int y, boolean dragged) {
    if( x < 0 || y < 0) return false; //25 pixel right and bottom for row editing
    if( x > this.width() + 25 || y > this.height() + 25) return false; //25 pixel right and bottom for row editing
    PixelColor pc = this.current_frame().update(x / rad, y / rad, current_color, !dragged);
    if( pc == null ) return false;
    current_color = pc.clone();
    return true;
  }

  int num_frames() {
    return frames.size();
  }

  Frame next_frame() {
    current_frame_nr = (current_frame_nr + 1 ) % num_frames();
    return current_frame();
  }

  Frame previous_frame() {
    current_frame_nr = ( current_frame_nr == 0 ) ? num_frames() - 1 : current_frame_nr - 1;
    return current_frame();
  }

  Frame first_frame() {
    current_frame_nr = 0;
    return current_frame();
  }

  /* +++++++++++++++ DATA STRUCTURE +++++++++++++++ */
  Frame current_frame() {
    return frame(current_frame_nr);
  }

  Frame frame(int f) {
    try {
      return (Frame) frames.get(f);
    }
    catch(Exception e ) {
      return (Frame) frames.get(0);
    }
  }

  void set_pixel(int f, int x, int y, PixelColor pc) {
    frame(f).set_colored_pixel(x, y, pc);
  }

  /* +++++++++++++++ FRAME +++++++++++++++ */
  Frame copy_frame() {
    copy_frame = current_frame().clone();
    return current_frame();
  }

  /* +++++++++++++++ FRAME +++++++++++++++ */
  Frame paste_frame() {
    if( copy_frame != null) frames.set(current_frame_nr, copy_frame.clone()); // better use set_pixel here!?
    return current_frame();
  }

  Frame add_frame() {
    if(!frames.isEmpty()) current_frame_nr++;
    frames.add(current_frame_nr, new Frame(this.cols, this.rows)); //init first frame
    return current_frame();
  }

  Frame delete_frame() {
    matrix.copy_frame();
    if(this.num_frames() > 1) {
      frames.remove(current_frame_nr);
      current_frame_nr = current_frame_nr % num_frames();
    }
    return current_frame();
  }

  /* +++++++++++++++ FILE +++++++++++++++ */
  void save_to_file(String savePath) {
    if( match(savePath, ".bmp") == null )  savePath += ".bmp";

    int height = (int) Math.sqrt(this.num_frames());
    while( this.num_frames() % height != 0) {
      height--;
    }
    int width =  this.num_frames() / height;

    PImage output = createImage( width * this.cols, height * this.rows, RGB);

    for(int h = 0; h < height; h++) {
      for(int w = 0; w < width; w++) {
        Frame frame = this.frame(h*width + w);
        for(int y = 0; y < frame.rows; y++) {
          for(int x = 0; x < frame.cols; x++) {
            output.set(x + frame.cols * w, y + frame.rows * h, frame.get_pixel(x,y).get_color() );
          }
        }
      }
    }
    output.save(savePath); //TODO add scaling??
    println("SAVED to " + savePath);
  }

  Matrix load_mtx(String loadPath) {
    PixelColor pc;
    Matrix matrix = new Matrix(this.cols, this.rows); //actually we have to read values from File!
    Frame frame = matrix.current_frame();
    BufferedReader reader = createReader(loadPath);
    String line = "";
    while( line != null ) {
      try {
        line = reader.readLine();
        if(line != null && line.length() > 0) {
          String[] str = line.split(",");
          for(int y = 0; y < frame.rows; y++) {
            //invert matrix
            pc = new PixelColor(~Integer.parseInt(str[y*3]), ~Integer.parseInt(str[y*3 + 1]), ~Integer.parseInt(str[y*3 + 2]) );
            frame.set_row(7-y, pc );
          }
          frame = matrix.add_frame();
        }
      }
      catch (IOException e) {
        e.printStackTrace();
        return matrix;
      }
    }
    matrix.delete_frame();
    return matrix;
  }

  Matrix load_bmp(String loadPath) {
    Matrix matrix = new Matrix(this.cols, this.rows);

    PImage input = loadImage(loadPath);
    input.loadPixels();

    int width = input.width / this.cols / SCALE;
    int height = input.height / this.rows / SCALE;
    Frame frame = matrix.current_frame();
    for(int h = 0; h < height; h++) {
      for(int w = 0; w < width; w++) {
        for(int y = 0; y < frame.rows; y++) {
          for(int x = 0; x < frame.cols; x++) {
            int off = h * width * frame.cols * frame.rows + w * frame.cols + y * (frame.cols * width) + x ;
            color c = input.pixels[off * SCALE];
            frame.get_pixel(x, y).set_color(c);
          }
        }
        frame = matrix.add_frame();
      }
    }
    matrix.delete_frame();
    return matrix;
  }
}

