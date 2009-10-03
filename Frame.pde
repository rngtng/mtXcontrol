class Frame {

  //static 
  PGraphics pg = null;
  Pixel[] pixs  = null;
  
  PGraphics frame = null;
  PGraphics thumb = null;
  
  public int rows = 0;
  public int cols = 0;
  
  public Pixel last_color = null;
  int last_y = 0;
  int last_x = 0;
   
  Frame( int cols, int rows ) {
    this.cols = cols;    
    this.rows = rows;
    this.pixs = new Pixel[rows*cols];
    this.last_color = new Pixel();
    this.clear();
    this.pg = createGraphics(8, 10, P2D);
  }
   
  public PGraphics draw_full(int draw_rad, int draw_border) {
    if(this.frame == null) this.frame = draw_canvas(draw_rad, draw_border);
    return this.frame;
  }
  
  public PGraphics draw_thumb(int draw_rad, int draw_border) {
    if(this.thumb == null) this.thumb = draw_canvas(draw_rad, draw_border);
    return this.thumb;
  }
  
  public PGraphics draw_canvas(int draw_rad, int draw_border) {
    Pixel pixel; 
    PGraphics canvas = createGraphics(this.cols * draw_rad, this.rows * draw_rad, P2D);   
    canvas.beginDraw();
    canvas.background(55);
    canvas.smooth();
    canvas.noStroke();   
    for(int y = 0; y < this.rows; y++) {
      for(int x = 0; x < this.cols; x++) {      
        canvas.fill(this.get_pixel(x,y).get_color());      
        canvas.ellipse( draw_rad * (x + 0.5), draw_rad * (y + 0.5), draw_rad-border, draw_rad-border);
      }
    }
    println( "drawn" );
    canvas.endDraw();   
    return canvas;
  }

  public void clear() {
    this.set_pixels(new Pixel());
  }

  public void fill() {
    this.set_pixels( last_color );
  }

  public void set_pixels(Pixel pix) {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        set_pixel(x, y, pix);
      }
    }
  }

  public void set_pixels(Pixel[] pix) {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        set_pixel(x, y, pix[pos(x,y)]);
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
    Pixel last = null;
    for( int x = 0; x < this.cols; x++ ) {
      last = set_pixel(x, y, new Pixel( (r >> x) & 1, (g >> x) & 1, (b >> x) & 1 ) );
    }
    return last;
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
    if( this.get_pixel(x,y).equal(pix) ) {
      this.frame = null;
      this.thumb = null;
      return this.get_pixel(x,y).invert();
    }
    return set_pixel(x, y, pix);
  }

  public Pixel set_pixel(int x, int y, Pixel pix) {    
    if( pix == null ) pix = new Pixel();
    if(get_pixel(x,y) != null ) {
      pixs[pos(x,y)].set_copied_values(pix);
    }
    else { 
      pixs[pos(x,y)] = pix.clone();
    }
    this.frame = null;
    this.thumb = null;
    return get_pixel(x,y);
  }
  
  public boolean update( int x, int y, boolean ignore_last) {
    if(!ignore_last && x == last_x && y == last_y) return false;
    last_color = set_colored_pixel(x, y, last_color);
    last_x = x;
    last_y = y;
    return true;
  }

  public Frame clone() {
    Frame f = new Frame(this.cols, this.rows);
    f.set_pixels(pixs);
    return f;
  }

  public void shift_left() {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        set_pixel(x, y, ( x < this.cols - 1) ? get_pixel(x+1,y) : null );
      }
    }
  }
  
  public void shift_right() {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = this.cols - 1; x >= 0; x-- ) {            
        set_pixel(x, y, ( x > 0) ? get_pixel(x-1,y) : null );
      }
    }
  }
  
  public void shift_up() {
    for( int y = 0; y < this.rows; y++ ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        set_pixel(x, y, ( y < this.rows - 1) ? get_pixel(x,y+1) : null );
      }
    }
  }

  public void shift_down() {
    for( int y = this.rows - 1; y >= 0; y-- ) { 
      for( int x = 0; x < this.cols; x++ ) {            
        set_pixel(x, y, ( y > 0) ? get_pixel(x,y-1) : null );
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
          this.set_pixel(col,row-offset,null);
        }
      }
      if(sum == 0 && offset < 2) offset++; 
      if(row-offset == 7) return; //exit earlier in case we dont have lower parts
    }
  }

}


