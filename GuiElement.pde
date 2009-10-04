class GuiElement {
  int x, y;
  color basecolor;
  boolean hide = false;
  
  GuiElement(int ix, int iy, color icolor) {
    this.x = ix;
    this.y = iy;
    this.basecolor = icolor;
  }

  public void display() {
    display(false);
  }

  public void display(boolean ihide) {
    this.hide = ihide;
    if(this.hide) return;
    stroke(30);
    fill(current_color());
  }
  
  /* ************************************************************************** */
  protected color current_color() {
    return this.basecolor;
  } 

}

class TextElement extends TextButton {
  
  TextElement( String itext, int ix, int iy ) {
    super(itext, ix, iy, 0, 0, #000000, #000000);
  }
  
  public void display(boolean ihide) {
    this.hide = ihide;
    if(this.hide) return;    
    textFont(fontA, 15);
    fill(255);
    text(this.current_text(), x, y + 25);
  }
  
}
