class Frame {

  //static 
  PGraphics pg = null;
  Pixel[] pixs  = null;

  public int rows = 0;
  public int cols = 0;
  
  Pixel last_color = null;
  int last_y = 0;
  int last_x = 0;
  
  Frame( int cols, int rows ) {
    this.cols = cols;    
    this.rows = rows;
    pixs = new Pixel[rows*cols];
    this.clear();
    this.pg = createGraphics(8, 10, P2D);
  }

  public void clear() {
    this.set_pixels(new Pixel());
  }

  public void fill_frame() {
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
      pix = set_colored_pixel(x, y, pix);
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
      pix = set_colored_pixel(x, y, pix);
    }
    return pix;
  }

  public Pixel set_colored_pixel(int x, int y, Pixel pix) {    
    if( x >= cols ) return set_row( y, pix);
    if( y >= rows)  return set_col( x, pix);    
    Pixel current = pixs[pos(x,y)];
    if( current.equal(pix) ) {
      pixs[pos(x,y)].invert();
    }
    else {
      pixs[pos(x,y)].set_copied_values(pix);
    }
    return pixs[pos(x,y)];
  }

  public Pixel set_pixel(int x, int y, Pixel pix) {    
    pixs[pos(x,y)].set_copied_values(pix);
    return pixs[pos(x,y)];
  }
  
  public Frame update( int x, int y, boolean ignore_last) {
    if(!ignore_last && x == last_x && y == last_y) return null;
    last_color = set_colored_pixel(x, y, last_color);
    last_x = x;
    last_y = y;
    return this;
  }

  public Frame clone() {
    Frame f = new Frame(this.cols, this.rows);
    f.set_pixels(pixs);
    return f;
  }

  public void shift_left() {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        pixs[pos(x,y)] = ( x < this.cols - 1) ? pixs[pos(x+1,y)] : new Pixel();
      }
    }
  }
  
  public void shift_right() {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = this.cols - 1; x >= 0; x-- ) {            
        pixs[pos(x,y)] = ( x > 0) ? pixs[pos(x-1,y)] : new Pixel();
      }
    }
  }
  
  public void shift_up() {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        pixs[pos(x,y)] = ( y < this.rows - 1) ? pixs[pos(x,y+1)] : new Pixel();
      }
    }
  }

  public void shift_down() {
    for( int y = this.rows - 1; y >= 0; y-- ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        pixs[pos(x,y)] = ( y > 0) ? pixs[pos(x,y-1)] : new Pixel();
      }
    }
  }  

  private int pos(int x, int y ) {
    return (y * this.cols) + x;
  }
  
  private void set_letter(char letter, PFont font) {
    set_letter(letter, font, 50);
  }    

  private void set_letter(char letter, PFont font, int trashhold) {
    Pixel colour = last_color;
    Pixel last_pixel = null;
    int offset = 0;
    this.pg.beginDraw();    
    this.pg.fill(#FF0000); 
    this.pg.background(0);
    this.pg.textFont(font,10);
    this.pg.text(letter,0,8);
    this.pg.endDraw();
    this.pg.loadPixels();
    for(int row = 0; row < 10; row++) {
      int sum = 0;
      for(int col = 0; col < 8; col++) {
        if(red(this.pg.pixels[row*8+col]) > trashhold) {
          last_color = this.set_colored_pixel(col, row-offset, colour);
          sum++;
        }
        else {
          pixs[pos(col,row-offset)] = new Pixel();
        }
      }
      if(sum == 0 && offset < 2) offset++; 
      if(row-offset == 7) return; //exit earlier in case we dont have lower parts
    }
  }

}


