class PixelColor {
  public int r;
  public int g;
  public int b;

  int[] COLORS_R = {
    0,255};
  //0,85,170,255};
  int[] COLORS_G = {
    0,255};
  //0,85,170,255};    
  int[] COLORS_B = {
    0,255};
  //0};  

  PixelColor() {
    this(0,0,0);
  }

  PixelColor(int r, int g, int b) {
    set_color(r,g,b);
  }

  public PixelColor next_color() {
    this.set_color_index(this.to_int()+1);
    return this;
  }

  public int numColors() {
    return COLORS_R.length * COLORS_G.length * COLORS_B.length;
  }


  public boolean equal(PixelColor pc) {
    if(pc == null) return true;
    return this.r == pc.r && this.g == pc.g && this.b == pc.b;
  }

  public void set_color(PixelColor pc) {
    if(pc == null) return;
    this.r = pc.r;
    this.g = pc.g;
    this.b = pc.b;
  }

  public void set_color(int _r, int _g, int _b) {
    this.r = _r;
    this.g = _g;
    this.b = _b;
  }

  public void set_color_index(int i) {
    i = i % numColors();
    this.r = i / (COLORS_G.length * COLORS_B.length);
    this.g = (i / COLORS_B.length) - (this.r * COLORS_G.length) ;
    this.b = (i - (this.r * COLORS_G.length + this.g) * COLORS_B.length);
  }

  public void set_color(color c) {
    this.r = int(red(c)   / COLORS_R.length) - 1;
    this.g = int(green(c) / COLORS_G.length) - 1;
    this.b = int(blue(c)  / COLORS_B.length) - 1;
  }

  public PixelColor clone() {
    return new PixelColor(r,g,b);
  }

  public color get_color() {
    return color(COLORS_R[this.r], COLORS_G[this.g], COLORS_B[this.b]);
  } 

  public int to_int() {
    return (this.r*(COLORS_G.length) + this.g)*(COLORS_B.length) + b; 
  }
}






