/* Button Class Taken from Processiong.org Tutorials:
 -> http://processing.org/learning/topics/buttons.html

 And modified for lock parameter, added renamed rect to square button and added real rectbutton
  code cleanup
 */

class Button extends GuiElement
{
  public color highlightcolor;
  boolean over = false;
  //  boolean clicked = false;
  String shortcut = null;
  
  Button(int ix, int iy,  color icolor, color ihighlight) {
    super(ix, iy, icolor);
    this.highlightcolor = ihighlight;
  }

  public boolean clicked() {
    return (this.over && !this.disabled);  
  }

  public boolean key_pressed(int key_code, boolean mac, boolean crtl, boolean alt) {
    return (this.shortcut != null &&  !this.disabled);
  }
  
  public boolean over() {
    return false;
  }

  /* ************************************************************************** */
  protected color current_color() {
    return (this.over && !this.disabled) ? highlightcolor : basecolor;
  }

  protected boolean overRect(int x, int y, int width, int height) {
    return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
  }

  protected boolean overCircle(int x, int y, int diameter) {
    float disX = x - mouseX;
    float disY = y - mouseY;
    return (sqrt(sq(disX) + sq(disY)) < diameter/2 );
  }
}

class CircleButton extends Button {
  int size;

  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) {
    super( ix, iy, icolor, ihighlight);
    this.size = isize;
  }

  public boolean over() {
    boolean old_over = this.over;
    this.over = overCircle(x, y, size);
    return this.over != old_over;
  }

  public boolean display()  {
    if( !super.display() ) return false;
    ellipse(x, y, size, size);
    return true;
  }
}

class RectButton extends Button {
  int width, height;

  RectButton(int ix, int iy, int iwidth, int iheight, color icolor) {
    this( ix, iy, iwidth, iheight, icolor, icolor);
  }

  RectButton(int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super( ix, iy, icolor, ihighlight);
    this.width = iwidth;
    this.height = iheight;
  }

  public boolean over() {
    boolean old_over =  this.over;
    this.over = overRect(x, y, width, height);
    return this.over != old_over;
  }

  public boolean display() {
    if( !super.display() ) return false;
    rect(x, y, width, height);
    return true;
  }
}

class SquareButton extends RectButton {

  SquareButton(int ix, int iy, int isize, color icolor, color ihighlight)  {
    super(ix, iy, isize, isize, icolor, ihighlight);
  }
}

class TextButton extends RectButton {
  String button_text;
  public color text_color;
  float x_offset;
  float y_offset;
  
  TextButton(String itext, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super(ix, iy, iwidth, iheight, icolor, ihighlight);
    this.button_text = itext;
  }

  public boolean display() {
    if( !super.display() ) return false;
    textFont(fontA, 15);
    fill(current_text_color());
    update_offset();
    text(this.current_text(), x_offset, y_offset);
    return true;
  }

  protected color current_text_color() {
    return (this.disabled) ? #666666 : #FFFFFF;
  }
  
  protected String current_text() {
    return this.button_text;
  }
  
  protected void update_offset() {
    x_offset = x + (this.width - textWidth(current_text())) / 2;
    y_offset = y + 17;
  }
  
}

class ActionButton extends TextButton {

  ActionButton(String itext, String ishortcut, int ix, int iy) {
    this(itext, ishortcut, ix, iy, 134, 25, #444444, #999999);
  }

  ActionButton(String itext, String ishortcut, int ix, int iy,  int iwidth, int iheight) {
    this(itext, ishortcut, ix, iy, iwidth, iheight, #444444, #999999);
  }

  ActionButton(String itext, String ishortcut, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight) {
    super(itext, ix, iy, iwidth, iheight, icolor, ihighlight);
    this.shortcut = ishortcut;
  }

  public boolean clicked() {
    if(!super.clicked()) return false;
    perform_action();
    return true;
  }

  public boolean key_pressed(int key_code, boolean mac, boolean crtl, boolean alt) {
    if(!super.key_pressed(key_code, mac, crtl, alt)) return false;
    String code = "";
    if(mac)  code = "m+" + code;
    if(crtl) code = "c+" + code;
    if(alt) code = "a+" + code;
    if(!this.shortcut.equals(code+char(key_code)) && !this.shortcut.equals(code+key_code)) return false; //no shortcut defined
    perform_action();
    return true;
  }

  protected void perform_action() {
    if(this.button_text == "^") matrix.current_frame().shift_up();
    if(this.button_text == "v") matrix.current_frame().shift_down();
    if(this.button_text == "<") matrix.current_frame().shift_left();
    if(this.button_text == ">") matrix.current_frame().shift_right();
    if(this.shortcut    == "m+L") { matrix = matrix.load_from_file(); keyMac  = false;}
    if(this.shortcut    == "m+S") { matrix.save_to_file(); keyMac  = false;}
    if(this.shortcut    == "a+L" && device instanceof StandaloneDevice) matrix = ((StandaloneDevice) device).read_matrix();
    if(this.shortcut    == "a+S" && device instanceof StandaloneDevice) ((StandaloneDevice) device).write_matrix(matrix);
    if(this.button_text == "Add")    matrix.add_frame();
    if(this.button_text == "Delete") matrix.delete_frame();
    if(this.button_text == "Copy")   matrix.copy_frame();
    if(this.button_text == "Paste")  matrix.paste_frame();
    if(this.button_text == "Fill")   matrix.current_frame().fill(matrix.current_color);
    if(this.button_text == "Clear")  matrix.current_frame().clear();
  }
}

class ActionToggleButton extends ActionButton {
  String button_text2;
  boolean locked = false;

  ActionToggleButton(String itext, String itext2, String ishortcut, int ix, int iy)  {
    this(itext, itext2, ishortcut, ix, iy, 134, 25, #444444, #999999);
  }

  ActionToggleButton(String itext, String itext2, String ishortcut, int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight)  {
    super(itext, ishortcut, ix, iy, iwidth, iheight, icolor, ihighlight);
    this.button_text2 = itext2;
  }

  protected String current_text() {
    return this.locked ?  this.button_text2 : this.button_text;
  }

  protected void perform_action() {
     if(this.shortcut == "10") { locked = !locked; toggle_mode(); } // ENTER
     if(this.shortcut == "a+10" && device instanceof StandaloneDevice)  { locked = !locked; ((StandaloneDevice) device).toggle(); } // ENTER
  }
}

class MiniColorButton extends RectButton {

  PixelColor px;
  
  MiniColorButton(int ix, int iy, int iwidth, int iheight, PixelColor icolor) {
    super(ix, iy, iwidth, iheight, icolor.get_color(), icolor.get_color());
    this.px = icolor;    
  }

  public boolean clicked() {
    if(!super.clicked()) return false;
    matrix.current_color.set_color(this.px);
    return true;
  }
  
  public boolean display() {
    if( !super.display() ) return false;
    if(matrix.current_color.equal(this.px)) {
      stroke(#FFFF00);
      strokeWeight(2);
      rect(this.x-1, this.y-1, this.width-1, this.height+2);
      strokeWeight(0);
    }
    return true;
  }  
}
