
class Matrix {

  ArrayList frames  = new ArrayList();

  public int numX = 0;
  public int numY = 0;

  public int current_frame_nr;

  Matrix(int x, int y ) {
    this.numX = x;
    this.numY = y;
  }

  int numFrames() {
    return frames.size();
  }

  void next_frame() {
    current_frame_nr = (current_frame_nr + 1 ) % numFrames();  // (current_frame_nr >= frames.size() - 1) ? 0 : current_frame_nr + 1;
  }

  void previous_frame() {
    current_frame_nr = ( current_frame_nr == 0 ) ? numFrames() - 1 : current_frame_nr - 1;
  }

  /* +++++++++++++++ DATA STRUCTURE +++++++++++++++ */
  byte[] current_frame() {
    return frame(current_frame_nr);
  }

  byte current_row(int y) {
    return row(current_frame_nr, y);
  }

  boolean current_pixel(int x, int y) {
    return pixel(current_frame_nr, x, y);
  }

  void invert_current_pixel( int x, int y ) {
    invert_pixel( current_frame_nr, x, y );
  }

  byte[] frame(int f) {
    try {
      return (byte[]) frames.get(f);
    }
    catch(Exception e ) {
      return (byte[]) frames.get(0);
    }
  }

  byte row(int f, int y) {
    return (byte) frame(f)[y];
  }

  boolean pixel(int f, int x, int y) {
    return (row(f, y) & (1 << x)) > 0;
  }

  void invert_pixel( int f, int x, int y ) {
    if( x >= numX || y >= numY) return;
    frame(f)[y] = (byte) (row(f,y) ^ (1 << x));
  }



  /* +++++++++++++++ FILE +++++++++++++++ */
  void save_to_file() {
    String savePath = selectOutput();  // Opens file chooser
    if (savePath == null) {
      println("No output file was selected...");
      return;
    }
    PrintWriter output = createWriter(savePath);
    // output.println(numX+","+numY+","+speed);

    for(int f=0; f< frames.size(); f++) {
      for(int y=0; y<numY; y++) {
        output.print(row(f,y) + ",");
      }
      output.println();
    }

    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    println("SAVED to " + savePath);
  }

  Matrix load_from_file() {
    String loadPath = selectInput("Choose a Matrix File to load");  // Opens file chooser
    Matrix matrix = new Matrix( numX, numY);
    if (loadPath == null) {
      println("No file was selected...");
      return matrix;
    }
    
    BufferedReader reader = createReader(loadPath);
    String line = "";
    current_frame_nr = 0;
    while( line != null ) {
      try {
        line = reader.readLine();
        if( line != null && line.length() > 0) matrix.add_frame( line.split(",") );
      }
      catch (IOException e) {
        e.printStackTrace();
        return matrix;
      }
    }
    matrix.current_frame_nr = 0;
    return matrix;
  }

  /* +++++++++++++++ FRAME +++++++++++++++ */
  void copy_last_frame() {
    if(current_frame_nr == 0) return;
    for(int y=0; y< numY; y++) {
      frame(current_frame_nr)[y] = row(current_frame_nr-1, y);
    }
  }

  void clear_frame() {
    set_frame(current_frame_nr, (byte) 0);
  }

  void add_frame() {
    if( !frames.isEmpty()) current_frame_nr++;
    frames.add( current_frame_nr, new byte[numY]); //init first frame
  }

  void add_frame(String[] values) {
    add_frame();
    set_frame(current_frame_nr, values);
  }

  void fill_frame() {
    set_frame( current_frame_nr, (byte) ((1 << numX ) - 1) );
  }

  void delete_frame() {
    if( current_frame_nr == 0) return;
    frames.remove(current_frame_nr);
    current_frame_nr--;
  }

  void set_frame(int f, byte value ) {
    for(int y=0; y< numY; y++) {
      frame(f)[y] = value;
    }
  }

  void set_frame(int f, byte[] values ) {
    for(int y=0; y< numY; y++) {
      frame(f)[y] = values[y];
    }
  } 

  void set_frame(int f, String[] values ) {
    for(int y=0; y< numY; y++) {
      frame(f)[y] = (byte) Integer.parseInt(values[y]);
    }
  } 

}


