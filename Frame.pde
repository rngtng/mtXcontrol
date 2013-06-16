class Frame {

  //static
  PGraphics pg = null;
  int letter_scale = 3;
  PixelColor[] pixs  = null;

  PGraphics frame = null;
  PGraphics thumb = null;

  public int rows = 0;
  public int cols = 0;

  int last_y = 0;
  int last_x = 0;

  Frame(int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    this.pixs = new PixelColor[rows*cols];
    this.clear();
    size(780, 720, P2D);
    this.pg = createGraphics(8*letter_scale, 10*letter_scale, P2D);
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
    PGraphics canvas = createGraphics(this.cols * draw_rad, this.rows * draw_rad, P2D);
    canvas.beginDraw();
    canvas.background(55);
    canvas.smooth();
    canvas.noStroke();
    canvas.rectMode(CENTER);
    for(int y = 0; y < this.rows; y++) {
      for(int x = 0; x < this.cols; x++) {
        canvas.fill(this.get_pixel(x,y).get_color());
        if(device.draw_as_circle()) {
          canvas.ellipse( draw_rad * (x + 0.5), draw_rad * (y + 0.5), draw_rad-border, draw_rad-border);
        }
        else {  
          canvas.rect( draw_rad * (x + 0.5), draw_rad * (y + 0.5), draw_rad-border, draw_rad-border);
        }  
      }
    }
  //  println( "drawn" );
    canvas.endDraw();
    return canvas;
  }

  public void clear() {
    this.set_pixels(new PixelColor());
  }

  public void fill(PixelColor pc) {
    this.set_pixels(pc);
  }
    
  public void set_pixels(PixelColor pc) {
    for( int y = 0; y < this.rows; y++ ) {
      for( int x = 0; x < this.cols; x++ ) {
        set_pixel(x, y, pc);
      }
    }
  }

  public void set_pixels(PixelColor[] pix) {
    for( int y = 0; y < this.rows; y++ ) {
      for( int x = 0; x < this.cols; x++ ) {
        set_pixel(x, y, pix[pos(x,y)]);
      }
    }
  }

  public PixelColor get_pixel(int x, int y) {
    if(x < 0 || y < 0 || x > width || y > height ) return null;
    return pixs[pos(x,y)];
  }

  public PixelColor set_row(int y, PixelColor pc) {
    for( int x = 0; x < this.cols; x++ ) {
      pc = set_colored_pixel(x, y, pc);
    }
    return pc;
  }

  public PixelColor set_col(int x, PixelColor pc) {
    for( int y = 0; y < this.rows; y++ ) {
      pc = set_colored_pixel(x, y, pc);
    }
    return pc;
  }

  public PixelColor set_colored_pixel(int x, int y, PixelColor pc) {
    if( x >= cols ) return set_row( y, pc);
    if( y >= rows)  return set_col( x, pc);
    if( this.get_pixel(x,y).equal(pc) ) {
      this.frame = null;
      this.thumb = null;
      return this.get_pixel(x,y).next_color();
    }
    return set_pixel(x, y, pc);
  }

  public PixelColor set_pixel(int x, int y, PixelColor pc) {
    if( pc == null ) pc = new PixelColor();
    if(this.get_pixel(x,y) != null ) {
      this.get_pixel(x,y).set_color(pc);
    }
    else {
      pixs[pos(x,y)] = pc.clone();
    }
    this.frame = null;
    this.thumb = null;
    return this.get_pixel(x,y).clone();
  }

  public PixelColor update(int x, int y, PixelColor pc, boolean ignore_last) {
    if(!ignore_last && x == last_x && y == last_y) return null;
    last_x = x;
    last_y = y;
    if(color_mode) return set_pixel(x, y, pc);
    return set_colored_pixel(x, y, pc);    
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

  private PixelColor set_letter(char letter, PFont font, PixelColor pc) {
    return set_letter(letter, font, pc, 50);
  }

  private PixelColor set_letter(char letter, PFont font, PixelColor pc, int trashhold) {
    PixelColor new_pc = null;
    int offset = 0;
    this.pg.beginDraw();
    this.pg.fill(#FF0000);  //red
    this.pg.background(0);
    this.pg.textFont(font,10*letter_scale);
    this.pg.text(letter,0,8*letter_scale);
    this.pg.endDraw();
    this.pg.loadPixels();
    for(int row = 0; row < 10; row++) {
      int sum = 0;
      for(int col = 0; col < 8; col++) {
        if( this.get_pixs(row, col) > trashhold) {
          new_pc = this.set_colored_pixel(col, row-offset, pc);          
          sum++;
        }
      }
      if(sum == 0 && offset < 2) offset++;
      if(row-offset == 7) return new_pc; //exit earlier in case we dont have lower parts
    }
    return new_pc;
  }

  private int get_pixs(int x, int y) {
    int trashhold = 0;
    x *= this.letter_scale;
    y *= this.letter_scale;
    for(int k = 0; k < this.letter_scale; k++) {
      for(int k2 = 0; k2 < this.letter_scale; k2++) {
        trashhold += red(this.pg.pixels[(x+k)*8*this.letter_scale+y+k2]);
      }
    }
    return trashhold / (this.letter_scale * this.letter_scale);
  }
}
