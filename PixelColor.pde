static class PixelColorScheme {
  public static int[] R = {};
  public static int[] G = {};
  public static int[] B = {};
}

class PixelColor {
  public int r;
  public int g;
  public int b;

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

  public PixelColor previous_color() {
    this.set_color_index(this.to_int()-1);
    return this;
  }
  
  public int numColors() {
    return PixelColorScheme.R.length * PixelColorScheme.G.length * PixelColorScheme.B.length;
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
    if(i < 0) i += numColors();
    this.r = i / (PixelColorScheme.G.length * PixelColorScheme.B.length);
    this.g = (i / PixelColorScheme.B.length) - (this.r * PixelColorScheme.G.length) ;
    this.b = (i - (this.r * PixelColorScheme.G.length + this.g) * PixelColorScheme.B.length);
  }

  public void set_color(color c) {
    int l_index = PixelColorScheme.R.length - 1;
    this.r = int(red(c)   / PixelColorScheme.R[l_index] * l_index);

    l_index = PixelColorScheme.G.length - 1;
    this.g = int(green(c) / PixelColorScheme.G[l_index] * l_index);

    l_index = PixelColorScheme.B.length - 1;
    this.b = int(blue(c)  / PixelColorScheme.B[l_index] * l_index);
  }

  public PixelColor clone() {
    return new PixelColor(r,g,b);
  }

  public color get_color() {
    return color(PixelColorScheme.R[this.r], PixelColorScheme.G[this.g], PixelColorScheme.B[this.b]);
  } 

  public int to_int() {
    return (this.r*(PixelColorScheme.G.length) + this.g)*(PixelColorScheme.B.length) + b; 
  }
}



