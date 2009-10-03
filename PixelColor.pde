class PixelColor {
  public int r;
  public int g;
  public int b;

  PixelColor() {
    this(0,0,0);
  }

  PixelColor(int r, int g, int b) {
    this.r = (r != 0) ? -1 : 0;
    this.g = (g != 0) ? -1 : 0;
    this.b = (b != 0) ? -1 : 0;
  }

  public PixelColor invert() {
    if(r < 0) {
      if(g < 0) {
        b = ~b;
      }
      g = ~g;
    }
    r = ~r;
    return this;
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

  public PixelColor clone() {
    return new PixelColor(r,g,b);
  }

  public color get_color() {
    return color(-254 * this.r, -254 * this.g, -254 * this.b);
  }

  public int to_int() {
    return this.r + this.g + this.b;
  }
}

/*  PixelColor(color c) {
 thils(c, 40);
 }

 PixelColor(color c, int trashhold) {
 this.r = (  red(c) > trashhold) ? 1 : 0;
 this.g = (green(c) > trashhold) ? 1 : 0;
 this.b = ( blue(c) > trashhold) ? 1 : 0;
 }*/

