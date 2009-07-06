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
    this.set_pixels( new Pixel(1,1,1) );
  }

  public void set_pixels(Pixel pix) {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        pixs[pos(x,y)] = pix.clone();
      }
    }
  }

  public void set_pixels(Pixel[] pix) {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        pixs[pos(x,y)] = pix[pos(x,y)].clone();
      }
    }
  }

  public Pixel get_pixel(int x, int y) {
    return pixs[pos(x,y)];
  }

  private int[] get_row(int y) {
    int[] res = new int[3];
    for(int x = 0; x < this.cols; x++) {
      res[0] |= (pixs[pos(x,y)].r + 1) << x;
      res[1] |= (pixs[pos(x,y)].g + 1) << x;
      res[2] |= (pixs[pos(x,y)].b + 1) << x;
    }
    res[0] = ~res[0];
    res[1] = ~res[1];
    res[2] = ~res[2];
    return res;
  }

  public Pixel set_row(int y, Pixel pix) {    
    for( int x = 0; x < this.cols; x++ ) {
      pix = set_pixel(x, y, pix);
    }
    return pix;
  }

  public Pixel set_row(int y, int r, int g, int b) {
    for( int x = 0; x < this.cols; x++ ) {
      pixs[pos(x,y)] = new Pixel( (r >> x) & 1, (g >> x) & 1, (b >> x) & 1 );
    }
    return pixs[pos(this.cols-1,y)];
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

  public Frame clone() {
    Frame f = new Frame(this.cols, this.rows);
    f.set_pixels(pixs);
    return f;
  }

  private int pos(int x, int y ) {
    return (y * this.cols) + x;
  }

}

