class FrameChooser extends RectButton {

  int show_frames;

  int thumb_rad = 5;
  int thumb_border = 1;
  int thumb_width, thumb_height;

  int frame_border = 15;

  FrameChooser(int ix, int iy, int iwidth, int iheight) {
    super(ix, iy, iwidth, iheight, #111111, #FFFF00);
    PGraphics thumb = matrix.current_frame().draw_thumb(thumb_rad, thumb_border);    
    this.thumb_width = thumb.width;
    this.thumb_height = thumb.height;
    this.show_frames = floor(iwidth / (this.thumb_width + frame_border));    
    this.enable();
  }

  public boolean display() {
    if(this.hidden) return false;
    int frame_nr;
    for(int nr = 0; nr < this.show_frames; nr++) {
      frame_nr = this.get_frame_nr(nr);      
      display_frame(this.x + (this.thumb_width + frame_border) * nr , this.y, frame_nr);
    }
    return true;
  }

  private void display_frame(int frame_x, int frame_y, int frame_nr) {      
    if( frame_nr >= 0 && frame_nr < matrix.num_frames())  { 
      image(matrix.frame(frame_nr).draw_thumb(thumb_rad, thumb_border), frame_x + 1, frame_y + 1);
      fill(255); //white
      noStroke();
      textFont(fontA, 15);
      String ttext = "" + (frame_nr + 1);
      text(ttext, frame_x + ((thumb_width - textWidth(ttext)) / 2), frame_y + thumb_height + 17);    
    }
    noFill();
    stroke( (frame_nr == matrix.current_frame_nr) ? this.highlightcolor : this.basecolor );      
    rect(frame_x, frame_y, thumb_width+2, thumb_height+2);
  }

  public boolean clicked() {
    if(!super.clicked()) return false;
    int frame_nr =  this.get_frame_nr( (mouseX - this.x) / this.thumb_width );
    if( frame_nr >= matrix.num_frames()) return false;
    matrix.current_frame_nr = frame_nr;
    return true;      
  }

  public boolean key_pressed(int key_code, boolean mac, boolean crtl, boolean alt) {
    if(this.disabled) return false;
    if(mac || crtl || alt) return false;
    if(key_code == 37) matrix.previous_frame(); // arrow left  //use perform_ation here??
    if(key_code == 39) matrix.next_frame();     // arrow right
    return (key_code == 37 || key_code == 39);
  }

  private int get_frame_nr(int nr) {
    return ( matrix.current_frame_nr > (this.show_frames - 1) ) ? (matrix.current_frame_nr - (this.show_frames - 1) + nr) : nr;
  }
}




