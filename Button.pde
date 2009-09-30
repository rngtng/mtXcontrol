/* Button Class Taken from Processiong.org Tutorials:
 -> http://processing.org/learning/topics/buttons.html
 
 And modified for lock parameter, added renamed rect to square button and added real rectbutton
 * code cleanup
 */

class Button
{
  int x, y;
  int size;
  public color basecolor, highlightcolor;
  boolean over = false;
  //  boolean pressed = false;  
  boolean locked = false;   

  Button(int ix, int iy,  color icolor, color ihighlight) {
    this.x = ix;
    this.y = iy;
    this.basecolor = icolor;
    this.highlightcolor = ihighlight;
  }

  color current_color() {
    return this.over ? highlightcolor : basecolor;
  }

  boolean pressed() {
    if(this.over) locked = !locked;
    return locked;
  }

  boolean over() { 
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) {
    return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
  }

  boolean overCircle(int x, int y, int diameter) {
    float disX = x - mouseX;
    float disY = y - mouseY;
    return (sqrt(sq(disX) + sq(disY)) < diameter/2 );
  }

  void display() {
    stroke(30);
    fill(current_color());
  }
}

class CircleButton extends Button { 
  int size;

  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) {
    super( ix, iy, icolor, ihighlight);
    this.size = isize;
  }

  boolean over() {
    this.over = overCircle(x, y, size); 
    return over;
  }

  void display()  {
    super.display();
    ellipse(x, y, size, size);
  }
}

class RectButton extends Button {
  int width, height;

  RectButton(int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {   
    super( ix, iy, icolor, ihighlight);
    this.width = iwidth;
    this.height = iheight;
  }

  RectButton(int ix, int iy, int iwidth, int iheight, color icolor) {
    this( ix, iy, iwidth, iheight, icolor, icolor);
  }  

  boolean over() {
    this.over = overRect(x, y, width, height); 
    return over;
  }

  public void display() {
    super.display(); 
    rect(x, y, width, height);
  }  
}

class SquareButton extends RectButton {

  SquareButton(int ix, int iy, int isize, color icolor, color ihighlight)  {
    super(ix, iy, isize, isize, icolor, ihighlight);
  }
}

class TextButton extends RectButton {
  String button_text;

  TextButton( String itext, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super(ix, iy, iwidth, iheight, icolor, ihighlight);
    this.button_text = itext;
  }

  private String current_text() {
    return this.button_text;
  }

  public void display() {
    super.display();
    textFont(fontA, 15);
    fill(255);
    text(this.current_text(), x + (this.width -textWidth(this.button_text)) / 2, y + 17);
  }  
}

class TextToggleButton extends TextButton {
  String button_text2;

  TextToggleButton( String itext, String itext2, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight)  {
    super(itext,ix, iy, iwidth, iheight, icolor, ihighlight);
    this.button_text2 = itext2;
  }

  private String current_text() {
    return this.locked ?  this.button_text2 : this.button_text;
  } 
}

class ActionButton extends TextButton {

  ActionButton(String itext, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super(itext, ix, iy, iwidth, iheight, icolor, ihighlight);
  }

  public boolean pressed() {
    if(!this.over) return true; 
    if(this.button_text == "U") matrix.current_frame().shift_up();
    if(this.button_text == "D") matrix.current_frame().shift_down();
    if(this.button_text == "L") matrix.current_frame().shift_left();
    if(this.button_text == "R") matrix.current_frame().shift_right();
    if(this.button_text == "Load") matrix = matrix.load_from_file();
    if(this.button_text == "Save") matrix.save_to_file();
    if(this.button_text == "Add") matrix.add_frame();
    if(this.button_text == "Delete") matrix.delete_frame();
    if(this.button_text == "Fill") matrix.current_frame().fill();
    if(this.button_text == "Clear") matrix.current_frame().clear();    
    
    
    // if( key == 'c') matrix.copy_last_frame();  //C

    
    return true;
  }
}

