
class Matrix {

  ArrayList frames  = new ArrayList();
  PGraphics pg = null;
  
  public int rad    = 70;
  int border = 10;
  
  public int rows = 0;
  public int cols = 0;

  int current_frame_nr;

  Matrix(int cols, int rows ) {
    this.cols = cols; //X
    this.rows = rows; //Y
    this.pg = createGraphics(this.width(), this.height(), P2D);
    add_frame();
  }
  
  public int width() {
    return cols * rad;
  }

  public int height() {
    return rows * rad;
  }

  public PGraphics current_image() {
    Pixel pixel; 
    this.pg.beginDraw();    
    this.pg.background(55);
    this.pg.smooth();
    this.pg.noStroke();   
    for(int y=0; y<current_frame().rows; y++) {
      for(int x=0; x<current_frame().cols; x++) {      
        pixel = current_frame().get_pixel(x,y);
        this.pg.fill(pixel.get_color());      
        this.pg.ellipse( x*rad+rad/2, y*rad+rad/2, rad-border, rad-border);
      }
    }
    this.pg.endDraw();   
    return this.pg;
  }

  public Frame click(int x, int y) {
    return this.current_frame().update(x / rad, y / rad, true);
  }
  
  public Frame drag(int x, int y) {
    return this.current_frame().update(x / rad, y / rad, false);
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

  void set_pixel(int f, int x, int y, Pixel colour) {      
    frame(f).set_colored_pixel(x,y,colour);        
  } 

  /* +++++++++++++++ FRAME +++++++++++++++ */
  Frame copy_last_frame() {
    if(current_frame_nr != 0) {
      Frame prev_frame = (Frame) frames.get(current_frame_nr - 1);
      frames.set(current_frame_nr, prev_frame.clone() );
    }    
    return current_frame();
  }

  Frame add_frame() {
    if( !frames.isEmpty()) current_frame_nr++;
    frames.add( current_frame_nr, new Frame(this.cols, this.rows)); //init first frame
    return current_frame();
  }

  Frame delete_frame() {
    if( current_frame_nr != 0) { 
      frames.remove(current_frame_nr);
      current_frame_nr--;
    }
    return current_frame();
  }

  /* +++++++++++++++ FILE +++++++++++++++ */
  void save_to_file() {
    String savePath = selectOutput();  // Opens file chooser
    if (savePath == null) {
      println("No output file was selected...");
      return;
    }
    PrintWriter output = createWriter(savePath);
    // output.println(rows+","+cols+","+speed);

    for(int f=0; f< this.num_frames(); f++) {
      Frame frame = this.frame(f);
      for(int y=0; y<frame.rows; y++) {
        int[] row = frame.get_row(y);
        output.print(row[0] + "," + row[1] + "," + row[2] + ",");
      }
      output.println();
    }

    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    println("SAVED to " + savePath);
  }

  Matrix load_from_file() {
    String loadPath = selectInput("Choose a Matrix File to load");  // Opens file chooser
    Matrix matrix = new Matrix( this.cols, this.rows); //actually we have to read values from File!
    if (loadPath == null) {
      println("No file was selected...");
      matrix.add_frame();
      return matrix;
    }

    BufferedReader reader = createReader(loadPath);
    String line = "";
    while( line != null ) {
      try {
        line = reader.readLine();
        if( line != null && line.length() > 0) {
          Frame frame = matrix.add_frame();
          String[] str = line.split(",");
          for(int y = 0; y < frame.rows; y++) {
            frame.set_row(y, Integer.parseInt(str[y*3]), Integer.parseInt(str[y*3 + 1]), Integer.parseInt(str[y*3 + 2]));           
          }
        }
      }
      catch (IOException e) {
        e.printStackTrace();
        return matrix;
      }
    }
    return matrix;
  } 

}


