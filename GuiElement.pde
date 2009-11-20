class GuiElement {
  int x, y;
  color basecolor;
  boolean hidden = false;
  boolean disabled = false;
  private boolean old_disabled = false;
  
  GuiElement(int ix, int iy, color icolor) {
    this.x = ix;
    this.y = iy;
    this.basecolor = icolor;
  }

  public void disable() {
    old_disabled = disabled;    
    disabled = true;
  }
  
  public void enable() {
    old_disabled = disabled;
    disabled = false;
  }

  public void toggle() {
    disabled = old_disabled;
    hidden = false;
  }

  public void hide() {
    hidden = true;
    disable();
  }

  public void show() {
    hidden = false;
    enable();
  }

  public boolean display() {
    if(this.hidden) return false;
    stroke(30);
    fill(current_color());
    return true;
  }
  
  /* ************************************************************************** */
  protected color current_color() {
    return this.basecolor;
  } 

}

class TextElement extends TextButton {
  
  TextElement( String itext, int ix, int iy ) {
    super(itext, ix, iy, 0, 0, #000000, #000000);
    this.disable();
  }

  protected color current_text_color() {
    return #FFFFFF;
  }

  
  protected void update_offset() {
    x_offset = x;
    y_offset = y + 25;
  }      
}
