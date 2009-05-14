class Matrix {  
  ArrayList frames  = new ArrayList();
  
  public int numX = 0;
  public int numY = 0;
  
  public int current_frame_nr;

  Matrix(int x, int y ) {
    numX = x;
    numY = y;    
    self.addFrame();
  }

  int numFrames() {
    frames.size();
  }
  
  void nextFrame() {
    current_frame_nr = (current_frame_nr >= frames.size() - 1) ? 0 : current_frame_nr + 1;
  }  

  /* +++++++++++++++ DATA STRUCTURE +++++++++++++++ */
  int[] current_frame() {
    return frame(current_frame_nr);
  }

  byte current_row(int y) {
    return row(current_frame_nr, y);
  }  

  boolean current_pixel(int x, int y) {
    return pixel(current_frame_nr, x, y);
  }

  int[] frame(int f) {
    try {
      return (int[]) frames.get(f);
    }
    catch(Exception e ) {
      return (int[]) frames.get(0);
    }
  }
  
  byte row(int f, int y) {
    return frame(f)[y];    
  }  
   
  boolean pixel(int f, int x, int y) {
    return (row(f, y) & (1 << x)) > 0;
  }

  
  void invert_current_pixel( int x, int y ) {
    matrix()[y] = matrix()[y] ^ (1 << x) ; 
  }

  /* +++++++++++++++ FILE +++++++++++++++ */
  void save_to_file() {
    String savePath = selectOutput();  // Opens file chooser
    if (savePath == null) {
      println("No output file was selected...");
      return;
    } 
    PrintWriter output = createWriter(savePath);
    output.println(numX+","+numY+","+speed);

    for(int f=0; f< frames.size(); f++) {
      for(int y=0; y<numY; y++) {
        output.print(matrix(f)[y] + ",");
      }
      output.println();
    } 

    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file  
    println("SAVED to " + savePath);     
  }

  void load_from_file() {
    String loadPath = selectInput("Choose a Matrix File to load");  // Opens file chooser
    if (loadPath == null) {
      println("No file was selected...");
      return;
    } 

    BufferedReader reader = createReader(loadPath);  
    String line = "";
    current_frame_nr = 0;
    while( line != null ) {
      try {
        line = reader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      } 
    }  
  }

  /* +++++++++++++++ FRAME +++++++++++++++ */
  void copyLastFrame() {
    if(current_frame_nr == 0) return;
    for(int y=0; y< numY; y++) {
      matrix()[y] = matrix(current_frame_nr-1)[y]; 
    }
  }

  void clearFrame() {
    setFrame(current_frame_nr, 0);
  }

  void addFrame() {
    if( !frames.isEmpty()) current_frame_nr++;
    frames.add( current_frame_nr, new int[numY]); //init first frame
  }

  void fillFrame() {
    setFrame(current_frame_nr, (1 << numX ) - 1);
  }

  void deleteFrame() {
    if( current_frame_nr == 0) return;
    frames.remove(current_frame_nr);
    current_frame_nr--;  
  }

  void setFrame(int f, int value ) {
    for(int y=0; y< numY; y++) {
      matrix(f)[y] = value; 
    }  
  }
}
