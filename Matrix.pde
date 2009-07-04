
class Matrix {

  ArrayList frames  = new ArrayList();

  public int rows = 0;
  public int cols = 0;

  public int current_frame_nr;

  Matrix(int cols, int rows ) {
    this.cols = cols; //X
    this.rows = rows; //Y
  }

  int num_frames() {
    return frames.size();
  }

  Frame next_frame() {
    current_frame_nr = (current_frame_nr + 1 ) % num_frames();  // (current_frame_nr >= frames.size() - 1) ? 0 : current_frame_nr + 1;
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

  void set_pixel( int f, int x, int y, Pixel colour ) {      
    frame(f).set_pixel(x,y,colour);        
  } 

  /* +++++++++++++++ FRAME +++++++++++++++ */
  Frame copy_last_frame() {
    //    if(current_frame_nr != 0) frames[current_frame_nr] = frames.get(current_frame_nr-1).clone();    
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

}



/* +++++++++++++++ FILE +++++++++++++++ 
 void save_to_file() {
 String savePath = selectOutput();  // Opens file chooser
 if (savePath == null) {
 println("No output file was selected...");
 return;
 }
 PrintWriter output = createWriter(savePath);
 // output.println(rows+","+cols+","+speed);
 
 for(int f=0; f< frames.size(); f++) {
 for(int y=0; y<cols; y++) {
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
 Matrix matrix = new Matrix( rows, cols);
 if (loadPath == null) {
 println("No file was selected...");
 matrix.add_frame();
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
 } */

