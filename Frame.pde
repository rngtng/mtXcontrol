class Frame {

  Pixel[] pixs  = null;

  public int rows = 0;
  public int cols = 0;

  Frame( int cols, int rows ) {
    this.cols = cols;    
    this.rows = rows;
    pixs = new Pixel[rows*cols];
    this.clear();
  }

  public void clear() {
    this.set_pixels(new Pixel());
  }

  public void fill() {
    this.set_pixels( new Pixel(-1,-1,-1) );
  }

  public void set_pixels(Pixel pix) {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        pixs[pos(x,y)] = pix.clone();
      }
    }
  }

  public Pixel get_pixel(int x, int y) {
    return pixs[pos(x,y)];
  }

  public Pixel[] get_row(int y) {
    Pixel[] pix = new Pixel[this.cols];
    for(int i = 0; i < pix.length; i++) {
      pix[i] = pixs[pos(i,y)];
    }
    return pix;
  }

  public Pixel set_row(int y, Pixel pix) {    
     Pixel last = pix;
    for( int x = 0; x < this.cols; x++ ) {
      pix = set_pixel(x, y, pix);
    }
    return pix;
  }

  public Pixel set_col(int x, Pixel pix) {    
    for( int y = 0; y < this.rows; y++ ) {
      pix = set_pixel(x, y, pix);
    }
    return pix;
  }

  public Pixel set_pixel(int x, int y, Pixel pix) {    
    if( x >= cols ) return set_row( y, pix);
    if( y >= rows)  return set_col( x, pix);    
    Pixel current = pixs[pos(x,y)];
    if( current.equal(pix) ) {
      pixs[pos(x,y)].invert();
    }
    else {
      pixs[pos(x,y)].copy(pix);
    }
    return pixs[pos(x,y)];
  }

  private int pos(int x, int y ) {
    return (y * this.cols) + x;
  }
}

////////#############################

/*
    for(int y=0; y< cols; y++) {
 frame[y] = new Pixel(0,0,0);
 }
 
 
 Pixel current_row(int y) {
 return row(current_frame_nr, y);
 }
 
 
 public Frame clone() {
 frame = new Frame(this.rows, this.cols);    
 return frame; 
 }
 
 
 boolean[] current_pixel(int x, int y) {
 return pixel(current_frame_nr, x, y);
 }
 
 
 void set_current_pixel( int x, int y, Pixel pix ) {
 invert_pixel( current_frame_nr, x, y, pix );
 }
 
 Pixel row(int f, int y) {
 return (Pixel) frame(f)[y];
 }
 
 Pixel pixel(int f, int x, int y) {
 return row(f, y);
 }
 
 
 Pixel[] frame = new Pixel[cols];
 
 void add_frame(String[] values) {
 add_frame();
 set_frame(current_frame_nr, values);
 }
 
 
 void set_frame(int f, Pixel value ) {
 for(int y=0; y< cols; y++) {
 frame(f)[y] = value.clone();
 }
 }
 
 void set_frame(int f, Pixel[] values ) {
 for(int y=0; y< cols; y++) {
 frame(f)[y] = values[y];
 }
 } 
 
 void set_frame(int f, String[] values ) {
 for(int y=0; y< cols; y++) {
 frame(f)[y] = new Pixel(values[y],"","");
 }
 } 
 
 */








