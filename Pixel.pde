class Pixel {
  public int r;
  public int g;
  public int b;
  
  Pixel( int r, int g, int b ) {
    this.r = (r != 0) ? -1 : 0;
    this.g = (g != 0) ? -1 : 0;
    this.b = (b != 0) ? -1 : 0;
  }

  Pixel() {
    this(0,0,0);
  }    

  public void invert() {
    if( r < 0) {
      if( g < 0 ) {       
        b = ~b;
      }
      g = ~g;
    }  
    r = ~r;          
  }
  
  public boolean equal(Pixel p) {
   if(p == null) return true;
   return this.r == p.r && this.g == p.g && this.b == p.b;
  }
  
  public void copy(Pixel p) {
   if(p == null) return;
   this.r = p.r;
   this.g = p.g;
   this.b = p.b;
  }

  public Pixel clone() {
    return new Pixel(r,g,b); 
  }
}
