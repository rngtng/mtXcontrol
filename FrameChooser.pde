class FrameChooser extends RectButton {

  int frame_width;
  int show_frames;
  
  FrameChooser(int ix, int iy, int iwidth, int ishow_frames) {
    super(ix, iy, iwidth * ishow_frames, iwidth, #111111, #FFFF00);
    this.frame_width = iwidth;
    this.show_frames = ishow_frames;
    this.enable();
  }

  public boolean display() {
    if(this.hidden) return false;
    int frame_nr;
    for(int nr = 0; nr < this.show_frames; nr++) {
      frame_nr = this.get_frame_nr(nr);      
      display_frame(this.x + this.frame_width * nr, this.y, frame_nr);
    }
    return true;
  }
  
  private void display_frame(int frame_x, int frame_y, int frame_nr) {
      noFill();
      stroke( (frame_nr == matrix.current_frame_nr) ? this.highlightcolor : this.basecolor );      
      rect(frame_x, this.y, this.frame_width - 10, this.frame_width - 10);    
      if( frame_nr < 0 || frame_nr >= matrix.num_frames()) return;
      image(matrix.frame(frame_nr).draw_thumb(6, 4), frame_x + 1, frame_y + 1);
      fill(255); //white
      noStroke();
      textFont(fontA, 15);
      text(frame_nr + 1, frame_x + 20, frame_y + 62);    
  }
   
  public boolean clicked() {
    if(!super.clicked()) return false;
    int frame_nr =  this.get_frame_nr( (mouseX - this.x) / this.frame_width );
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



