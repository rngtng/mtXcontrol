class Pixel {
  public int r;
  public int g;
  public int b;

  Pixel(int r, int g, int b) {
    this.r = (r != 0) ? -1 : 0;
    this.g = (g != 0) ? -1 : 0;
    this.b = (b != 0) ? -1 : 0;
  }

  Pixel() {
    this(0,0,0);
  }    

  public Pixel invert() {
    if(r < 0) {
      if(g < 0) {       
        b = ~b;
      }
      g = ~g;
    }  
    r = ~r;   
    return this;
  }

  public boolean equal(Pixel p) {
    if(p == null) return true;
    return this.r == p.r && this.g == p.g && this.b == p.b;
  }

  public void set_copied_values(Pixel p) {
    if(p == null) return;
    this.r = p.r;
    this.g = p.g;
    this.b = p.b;
  }

  public Pixel clone() {
    return new Pixel(r,g,b); 
  }

  public color get_color() {
    return color(-254 * this.r, -254 * this.g, -254 * this.b);
  }
  
  public int to_int() {
    return this.r + this.g + this.b;
  }
}


/*  Pixel(color c) {
    thils(c, 40);
  } 

  Pixel(color c, int trashhold) {
    this.r = (  red(c) > trashhold) ? 1 : 0;
    this.g = (green(c) > trashhold) ? 1 : 0; 
    this.b = ( blue(c) > trashhold) ? 1 : 0; 
  }*/
